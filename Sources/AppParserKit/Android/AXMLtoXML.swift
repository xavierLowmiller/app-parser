import Foundation

extension XMLParser {
	convenience init(axml: Data) throws {
		self.init(data: try axmlToXml(axml))
	}
}

func axmlToXml(_ axml: Data) throws -> Data {
	var bytes = [UInt8](axml)
	try bytes.validateHead()
	let strings = try bytes.parseStrings()
	try bytes.validateResources()

	return try bytes.parseTags(strings: strings)
}

private extension Array where Element == UInt8 {
	mutating func validateHead() throws {
		let headSection: UInt32 = 0x00080003
		let count = self.count
		guard nextWord() == headSection else { throw AxmlError.invalidFileSectionNumber }
		guard nextWord() == count else { throw AxmlError.invalidFileSizeChecksum }
	}

	mutating func parseStrings() throws -> [String] {
		let stringSection: UInt32 = 0x001c0001
		guard nextWord() == stringSection else { throw AxmlError.invalidStringSectionNumber }
		let chunkSize = nextWord()

		// The string section starts of with a bunch of metadata
		let numberOfStrings = nextWord()
		let numberOfStyles = nextWord()
		let flags = nextWord()

		let stringOffset = nextWord()
		let styleOffset = nextWord()

		let offsets = (0..<numberOfStrings).map { _ in nextWord() }
			+ [(styleOffset == 0 ? chunkSize : styleOffset) - stringOffset]

		// Skip style offsets
		removeFirst(Int(numberOfStyles) * 4)

		let stringLengths = zip(offsets, offsets.dropFirst()).map { $1 - $0 }

		let utf8Flag: UInt32 = 1 << 8
		let isUTF8 = (flags & utf8Flag) != 0

		let strings: [String]
		if isUTF8 {
			strings = stringLengths.map { readUTF8String(length: $0) }
		} else {
			strings = stringLengths.map { readUTF16String(length: $0) }
		}

		// Skip style data
		if styleOffset != 0 {
			removeFirst(Int(chunkSize - styleOffset))
		}

		return strings
	}

	mutating func validateResources() throws {
		let resourceSection = 0x00080180
		guard nextWord() == resourceSection else { throw AxmlError.invalidResourceSectionNumber }
		let chunkSize = nextWord()
		// Skip resource section
		removeFirst(Int(chunkSize) - 8)
	}

	private enum TagType: UInt32 {
		case startNamespace = 0x00100100
		case endNamespace = 0x00100101
		case startTag = 0x00100102
		case endTag = 0x00100103
		case text = 0x00100104
	}

	private struct Attribute {
		let id: UInt32
		let key: UInt32
		let value: UInt32
		let type: UInt32
		let data: UInt32


		func resolve(in strings: [String]) -> String {
			let key = strings[Int(self.key)]
			let value = self.value == .max
				? "resourceID 0x" + String(data, radix: 16)
				: strings[Int(self.value)]

			return "\(key)=\"\(value)\""
		}
	}

	mutating func parseTags(strings: [String]) throws -> Data {
		var xmlLines = [#"<?xml version="1.0" encoding="utf-8"?>"#]

		var currentNamespace: String? = nil
		var namespaceUrl: String? = nil
		var indentationLevel = 0

		while !isEmpty {
			let rawValue = nextWord()
			guard let tagType = TagType(rawValue: rawValue)
				else { throw AxmlError.unrecognizedTagType(rawValue) }

			removeFirst(4) // Chunk Size, unused
			removeFirst(4) // Line Number, unused
			removeFirst(4) // Unknown, unused

			switch tagType {
			case .startNamespace:
				let prefix = nextWord()
				let uri = nextWord()
				currentNamespace = strings[Int(prefix)]
				namespaceUrl = strings[Int(uri)]
			case .endNamespace:
				removeFirst(4) // class attribute, unused
				removeFirst(4) // class attribute, unused
				currentNamespace = nil
			case .startTag:
				let tagUri = nextWord()
				let tagName = nextWord()
				removeFirst(4) // Unknown flags
				let attributeCount = nextWord()
				removeFirst(4) // class attribute, unused

				let attributes = (0..<attributeCount).map { _ in
					Attribute(
						id: nextWord(),
						key: nextWord(),
						value: nextWord(),
						type: nextWord() >> 24,
						data: nextWord()
					).resolve(in: strings)
				}
				.map { $0.withNamespacePrefix(currentNamespace) }

				let namespaceUrlAttribute: String?
				if let _namespaceUrl = namespaceUrl {
					namespaceUrlAttribute = "xmlns:\(currentNamespace!)=\"\(_namespaceUrl)\""
					namespaceUrl = nil
				} else {
					namespaceUrlAttribute = nil
				}

				let name = strings[Int(tagName)]
				let tagContent = ([name, namespaceUrlAttribute] + attributes)
					.compactMap { $0 }
					.joined(separator: " ")
				xmlLines.append(spaces(for: indentationLevel) + "<\(tagContent)>")
				indentationLevel += 1
			case .endTag:
				indentationLevel -= 1
				let tagUri = nextWord()
				let tagName = nextWord()

				let name = strings[Int(tagName)]
				xmlLines.append(spaces(for: indentationLevel) + "</\(name)>")
			case .text:
				break
			}
		}

		return xmlLines
			.joined(separator: "\n")
			.data(using: .utf8)!
	}

	private mutating func readUTF8String(length: UInt32) -> String {
		defer { removeFirst(Int(length)) }
		let count = Int(self[1])
		let chars = self[2..<count + 2]
		return String(decoding: chars, as: UTF8.self)
	}

	private mutating func readUTF16String(length: UInt32) -> String {
		defer { removeFirst(Int(length)) }
		func getUInt16(at offset: Int) -> UInt16 {
			UInt16(self[offset + 1]) << 8 | UInt16(self[offset + 0])
		}
		let characterCount = getUInt16(at: 0)
		let chars = (0..<characterCount).map { offset in
			getUInt16(at: (Int(offset) + 1) * 2)
		}

		return String(decoding: chars, as: UTF16.self)
	}

	private mutating func nextWord() -> UInt32 {
		defer { removeFirst(4) }
		return UInt32(self[3]) << 24
			| UInt32(self[2]) << 16
			| UInt32(self[1]) << 8
			| UInt32(self[0]) << 0
	}

	mutating func skipWords(_ amount: UInt32) {
		removeFirst(4 * Int(amount))
	}
}

private func spaces(for indentation: Int) -> String {
	String([Character](repeating: " ", count: indentation * 4))
}

private extension String {
	func withNamespacePrefix(_ prefix: String?) -> String {
		if let prefix = prefix {
			return prefix + ":" + self
		} else {
			return self
		}
	}
}

enum AxmlError: Error {
	case invalidFileSectionNumber
	case invalidStringSectionNumber
	case invalidResourceSectionNumber
	case invalidFileSizeChecksum
	case unrecognizedTagType(UInt32)
}

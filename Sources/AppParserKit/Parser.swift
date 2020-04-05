import Foundation

public protocol Parser {
	static func parseMetadata(at path: String) throws -> AppMetadata
}

extension Parser {
	static func unzip(at path: String, filePattern: String = "") throws -> TemporaryFile {
		guard let name = path.split(separator: "/").last else { throw InvalidPathError() }

		let tempFile = try TemporaryFile(creatingTempDirectoryForFilename: String(name))

		shell("""
			unzip -qq \
			"\(path)" \
			\(filePattern) \
			-d "\(tempFile.directoryURL.path)"
			""")

		return tempFile
	}
}

struct InvalidPathError: Error {}

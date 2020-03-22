import Foundation

public enum IpaParser {

	/// Loads an .ipa's info.plist as a Swift dictionary
	/// - Parameter path: The path to the .ipa file
	static func loadInfoDictionary(at path: String) throws -> NSDictionary {
		guard let name = path.split(separator: "/").last else { throw InvalidPathError() }

		let fileURL = URL(fileURLWithPath: path)

		let tempFile = try TemporaryFile(creatingTempDirectoryForFilename: String(name))
		defer { try? tempFile.deleteDirectory() }

		unzip(at: fileURL, to: tempFile.directoryURL)

		let payloadDir = tempFile.directoryURL.path.appending("/Payload/")
		guard let appDir = try FileManager.default
			.contentsOfDirectory(atPath: payloadDir)
			.first(where:  { $0.hasSuffix(".app") })
			else { throw CorruptIPAStructure() }

		let infoPlistURL = URL(fileURLWithPath: payloadDir)
			.appendingPathComponent(appDir)
			.appendingPathComponent("Info.plist")

		guard let infoPlist = NSDictionary(contentsOf: infoPlistURL)
			else { throw InvalidInfoPlist() }

		return infoPlist
	}

	public static func parseMetadata(at path: String) throws -> AppMetadata {
		let infoPlist = try loadInfoDictionary(at: path)
		return try AppMetadata(infoPlist: infoPlist)
	}
}

struct InvalidPathError: Error {}
struct CorruptIPAStructure: Error {}
struct InvalidInfoPlist: Error {}

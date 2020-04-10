import Foundation

public enum IpaParser: Parser {

	/// Loads an .ipa's info.plist as a Swift dictionary
	/// - Parameter path: The path to the .ipa file
	static func loadInfoDictionary(at path: String) throws -> NSDictionary {
		let filePattern = "Payload/*/*.plist Payload/*/*.png"
		let tempFile = try unzip(at: path, filePattern: filePattern)
		defer { try? tempFile.deleteDirectory() }

		let payloadDir = tempFile.directoryURL.path.appending("/Payload/")
		guard let appDir = try FileManager.default
			.contentsOfDirectory(atPath: payloadDir)
			.first(where: { $0.hasSuffix(".app") })
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

struct CorruptIPAStructure: Error {}
struct InvalidInfoPlist: Error {}

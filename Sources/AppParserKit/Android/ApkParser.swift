import Foundation

public enum ApkParser: Parser {
	public static func parseMetadata(at path: String) throws -> AppMetadata {
		try parseMetadata(at: path, aaptPath: nil)
	}

	private static func parseAPK(at path: String) throws -> AndroidManifestParser {
		//		let filePattern = "AndroidManifest.xml */ic_launcher.png"
		let tempFile = try unzip(at: path, filePattern: "")
		defer { try? tempFile.deleteDirectory() }

		// .arsc File
//		do {
//			let manifestURL = tempFile.directoryURL.appendingPathComponent("Resources.asrc")
//			let axml = try Data(contentsOf: manifestURL)
//			let parser = try XMLParser(axml: axml)
//
//			let delegate = AndroidManifestParser()
//			parser.delegate = delegate
//			parser.parse()
//		}

		// Manifest
		do {
			let manifestURL = tempFile.directoryURL.appendingPathComponent("AndroidManifest.xml")
			let axml = try Data(contentsOf: manifestURL)
			let parser = try XMLParser(axml: axml)

			let delegate = AndroidManifestParser()
			parser.delegate = delegate
			parser.parse()

			return delegate
		}
	}

	public static func parseMetadata(at path: String, aaptPath: String? = nil) throws -> AppMetadata {
		let parser = try parseAPK(at: path)

		return try AppMetadata(from: parser)
	}
}

import Foundation

public enum ApkParser {
	public static func parseMetadata(at path: String, aaptPath: String? = nil) throws -> AppMetadata {
		let aaptOutput = aapt(path, aaptPath: aaptPath)
print(aaptOutput)
		return try AppMetadata(from: aaptOutput)
	}
}

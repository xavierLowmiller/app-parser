import AppParserKit
import ArgumentParser
import Foundation

public struct AppParser: ParsableCommand {

	public init() {}

	@Argument()
	var path: String

	@Option()
	var aaptPath: String?

	public func run() throws {

		let metadata: AppMetadata

		switch path {
		case _ where path.hasSuffix(".ipa"):
			metadata = try IpaParser.parseMetadata(at: path)
		case _ where path.hasSuffix(".apk"):
			metadata = try ApkParser.parseMetadata(at: path, aaptPath: aaptPath)
		default:
			throw UnsupportedError(path: path)
		}

		let data = try JSONEncoder().encode(metadata)
		print(String(decoding: data, as: UTF8.self))
	}
}

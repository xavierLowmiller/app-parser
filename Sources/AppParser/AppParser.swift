import AppParserKit
import ArgumentParser
import Foundation

public struct AppParser: ParsableCommand {

	public init() {}

	@Argument()
	var path: String

	public func run() throws {

		let metadata: AppMetadata

		switch path {
		case _ where path.hasSuffix(".ipa"):
			metadata = try IpaParser.parseMetadata(at: path)
		case _ where path.hasSuffix(".apk"):
			fatalError("TODO: Implement Android parsing")
		default:
			throw UnsupportedError(path: path)
		}

		let data = try JSONEncoder().encode(metadata)
		print(String(decoding: data, as: UTF8.self))
	}
}

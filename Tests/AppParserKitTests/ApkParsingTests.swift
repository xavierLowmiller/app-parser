import XCTest
import AppParserKit

final class ApkParsingTests: XCTestCase {
	func testBasicMetadata() throws {
		// Given
		let path = #file.components(separatedBy: "Tests")[0]
			.appending("Tests/Test Data/example.apk")

		// When
		let metadata = try ApkParser.parseMetadata(at: path, aaptPath: aaptPath)

		// Then
		XCTAssertEqual(metadata.identifier, "de.cineaste.android")
		XCTAssertEqual(metadata.version, "2.8.0")
		XCTAssertEqual(metadata.displayName, "Cineaste")
		XCTAssertEqual(metadata.operatingSystem, .android)
	}
}

#if os(macOS)
private let aaptPath = (#file.components(separatedBy: "/")
	.dropLast() + ["aapt-macOS"]).joined(separator: "/")
#elseif os(Linux)
private let aaptPath = (#file.components(separatedBy: "/")
	.dropLast() + ["aapt-linux"]).joined(separator: "/")
#endif

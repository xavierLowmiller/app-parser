import XCTest
import AppParserKit

final class IpaParsingTests: XCTestCase {
	func testBasicMetadata() throws {
		// Given
		let path = #file.components(separatedBy: "Tests")[0]
			.appending("Tests/Test Data/example.ipa")

		// When
		let metadata = try IpaParser.parseMetadata(at: path)

		// Then
		XCTAssertEqual(metadata.identifier, "de.spacepandas.ios.cineaste")
		XCTAssertEqual(metadata.version, "1.20.1")
		XCTAssertEqual(metadata.displayName, "Cineaste App")
		XCTAssertEqual(metadata.operatingSystem, .iOS)
	}
}

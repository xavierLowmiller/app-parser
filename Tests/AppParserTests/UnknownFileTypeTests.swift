import XCTest
@testable import AppParser

final class UnknownFileTypeTests: XCTestCase {
	func testUnknownFileTypesShouldThrowAnError() throws {
		// Given
		let path = "example.exe"

		// When
		let command = try AppParser.parse([path])

		// Then
		do {
			try command.run()
			XCTFail("An error should have been thrown here")
		} catch let error as UnsupportedError {
			XCTAssertEqual(error.localizedDescription, "Files of type exe aren't supported")
		}
	}
}

import XCTest

import AppParserKitTests
import AppParserTests

var tests = [XCTestCaseEntry]()
tests += AppParserKitTests.__allTests()
tests += AppParserTests.__allTests()

XCTMain(tests)

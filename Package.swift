// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "app-parser",
	platforms: [
		.macOS(.v10_12)
	],
	products: [
		.executable(name: "app-parser", targets: ["Run"])
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.2")
	],
	targets: [
		.target(name: "AppParserKit"),
		.target(
			name: "AppParser",
			dependencies: [
				.target(name: "AppParserKit"),
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			]
		),
		.target(name: "Run", dependencies: ["AppParser"]),
		.testTarget(
			name: "AppParserTests",
			dependencies: [.target(name: "AppParser")]),
		.testTarget(
			name: "AppParserKitTests",
			dependencies: [.target(name: "AppParserKit")]),
	]
)

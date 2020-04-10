// swift-tools-version:5.1
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
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.2"),
        .package(url: "https://github.com/xavierLowmiller/swift-axml-converter", from: "1.0.0")
	],
	targets: [
        .target(name: "AppParserKit", dependencies: ["AXML"]),
		.target(
			name: "AppParser",
			dependencies: [
				"AppParserKit",
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			]
		),
		.target(name: "Run", dependencies: ["AppParser"]),

		.testTarget(
			name: "AppParserTests",
			dependencies: ["AppParser"]),
		.testTarget(
			name: "AppParserKitTests",
			dependencies: ["AppParserKit"])
	]
)

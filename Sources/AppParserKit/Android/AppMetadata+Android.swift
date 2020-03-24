extension AppMetadata {
	init(from aaptOutput: String) throws {

		identifier = try aaptOutput.packageName()

		version = try aaptOutput.appVersion()

		displayName = try aaptOutput.displayName()

		operatingSystem = .android
	}
}

private extension String {
	func packageName() throws -> String {
		let lines = components(separatedBy: "\n")
		guard let packageLine = lines.first(where: { $0.contains("package: ") }),
			let name = packageLine.components(separatedBy: " ").first(where: { $0.hasPrefix("name=") })
			else { throw ApkParseError.missingPackageName }

		return name.components(separatedBy: "\'")[1]
	}

	func appVersion() throws -> String {
		let lines = components(separatedBy: "\n")
		guard let versionLine = lines.first(where: { $0.contains("package: ") }),
			let name = versionLine.components(separatedBy: " ").first(where: { $0.hasPrefix("versionName=") })
			else { throw ApkParseError.missingAppVersion }

		return name.components(separatedBy: "\'")[1]
	}

	func displayName() throws -> String {
		let lines = components(separatedBy: "\n")
		guard let applicationLabel = lines.first(where: { $0.contains("application-label:") })
			else { throw ApkParseError.missingDisplayName }

		return applicationLabel.components(separatedBy: "\'")[1]
	}
}

enum ApkParseError: Error {
	case missingPackageName
	case missingAppVersion
	case missingDisplayName
}

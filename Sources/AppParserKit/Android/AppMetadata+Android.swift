extension AppMetadata {
	init(from parser: AndroidManifestParser) throws {

		guard let identifier = parser.identifier
			else { throw ApkParseError.missingPackageName }
		guard let version = parser.version
			else { throw ApkParseError.missingAppVersion }
		guard let displayName = parser.displayName
			else { throw ApkParseError.missingDisplayName }

		self.identifier = identifier
		self.version = version
		self.displayName = displayName
		operatingSystem = .android
	}
}

enum ApkParseError: Error {
	case missingPackageName
	case missingAppVersion
	case missingDisplayName
}

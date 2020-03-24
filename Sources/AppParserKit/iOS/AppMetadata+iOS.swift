import Foundation

extension AppMetadata {
	init(infoPlist: NSDictionary) throws {
		guard let bundleID = infoPlist["CFBundleIdentifier"] as? String
			else { throw IpaParseError.noBundleIdFound }
		self.identifier = bundleID

		guard let version = infoPlist["CFBundleShortVersionString"] as? String
			else { throw IpaParseError.noVersionFound }
		self.version = version

		guard let displayName = infoPlist["CFBundleDisplayName"] as? String
				?? infoPlist["CFBundleName"] as? String
			else { throw IpaParseError.noDisplayNameFound }
		self.displayName = displayName

		self.operatingSystem = .iOS
	}
}

enum IpaParseError: Error {
	case noBundleIdFound
	case noVersionFound
	case noDisplayNameFound
}

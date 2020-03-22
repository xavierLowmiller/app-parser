import Foundation

extension AppMetadata {
	init(infoPlist: NSDictionary) throws {
		guard let bundleID = infoPlist["CFBundleIdentifier"] as? String
			else { throw IPAParseError.noBundleIdFound }
		self.id = bundleID

		guard let version = infoPlist["CFBundleShortVersionString"] as? String
			else { throw IPAParseError.noVersionFound }
		self.version = version

		guard let displayName = infoPlist["CFBundleDisplayName"] as? String
				?? infoPlist["CFBundleName"] as? String
			else { throw IPAParseError.noDisplayNameFound }
		self.displayName = displayName

		self.operatingSystem = .iOS
	}
}

enum IPAParseError: Error {
	case noBundleIdFound
	case noVersionFound
	case noDisplayNameFound
}

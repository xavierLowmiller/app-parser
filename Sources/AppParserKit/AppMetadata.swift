/// Contains Metadata parsed from a .apk or .apk file
public struct AppMetadata: Encodable {
	/// Reverse dot-notation unique identifier
	///
	/// Example: `"com.domain.appname"`
	public let identifier: String

	/// The marketing version numer
	///
	/// Example: `"2.3.9"`
	public let version: String

	/// The display name, as shown on SpringBoard and Launchers
	///
	/// Example: `"App Name"`
	public let displayName: String

	/// The operating system this app runs on
	public let operatingSystem: OperatingSystem
}

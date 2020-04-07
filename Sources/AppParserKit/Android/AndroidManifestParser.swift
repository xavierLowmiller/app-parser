import Foundation
final class AndroidManifestParser: NSObject, XMLParserDelegate {

	var identifier: String?
	var version: String?
	// TODO: Parse this from somewhere
//	var displayName: String?

	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes: [String: String] = [:]) {

		print("parsing <\(elementName)>:", attributes)

		switch elementName {
		case "manifest":
			identifier = attributes["package"]
			version = attributes["android:versionName"]
		default:
			break
		}
	}
}

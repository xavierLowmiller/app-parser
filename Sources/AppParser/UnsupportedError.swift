struct UnsupportedError: Error {
	let path: String

	var localizedDescription: String {
		let name = path.components(separatedBy: ".").last ?? path

		return "Files of type \(name) aren't supported"
	}
}

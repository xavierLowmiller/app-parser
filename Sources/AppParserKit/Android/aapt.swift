func aapt(_ path: String, aaptPath: String? = nil) -> String {
	let aapt = aaptPath ?? "aapt"
	return shell("\(aapt) dump badging \"\(path)\"")
}

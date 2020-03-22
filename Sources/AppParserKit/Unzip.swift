import Foundation

func unzip(at source: URL, to dest: URL) {

	shell("""
		unzip -qq \
		"\(source.path)" \
		Payload/*/*.plist \
		Payload/*/*.png \
		-d "\(dest.path)"
		""")
}


@discardableResult
func shell(_ args: String...) -> Int32 {
	let task = Process()
	task.launchPath = "/bin/sh"
	task.arguments = ["-c"] + args
	task.launch()
	task.waitUntilExit()
	return task.terminationStatus
}

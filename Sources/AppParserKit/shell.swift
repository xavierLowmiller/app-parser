import Foundation

@discardableResult
func shell(_ args: String...) -> String {
	let pipe = Pipe()
	let task = Process()
	task.launchPath = "/bin/sh"
	task.arguments = ["-c"] + args
	task.standardOutput = pipe
	task.launch()
	task.waitUntilExit()
	let output = pipe.fileHandleForReading.readDataToEndOfFile()
	return String(decoding: output, as: UTF8.self)
}

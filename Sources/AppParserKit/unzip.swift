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

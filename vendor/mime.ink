` mime type `

str := load('../vendor/str')
split := str.split

MimeTypes := {
	'html': 'text/html'
	'css': 'text/css'
	'js': 'application/javascript'
	'json': 'application/json'
	'ink': 'text/plain'

	'jpg': 'image/jpeg'
	'png': 'image/png'
	'svg': 'image/svg+xml'
}

forPath := path => (
	parts := split(path, '.')
	ending := parts.(len(parts) - 1)

	guess := MimeTypes.(ending) :: {
		() -> 'application/octet-stream'
		_ -> guess
	}
)

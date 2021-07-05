` main.ink serves files `

std := load('../vendor/std')
str := load('../vendor/str')

log := std.log
f := std.format
readFile := std.readFile

http := load('../vendor/http')
mimeForPath := load('../vendor/mime').forPath

Port := 9999

server := (http.new)()
NotFound := {status: 404, body: 'file not found'}
MethodNotAllowed := {status: 405, body: 'method not allowed'}

serveStatic := path => (req, end) => req.method :: {
	'GET' -> readFile('static/' + path, file => file :: {
		() -> end(NotFound)
		_ -> end({
			status: 200
			headers: {'Content-Type': mimeForPath(path)}
			body: file
		})
	})
	_ -> end(MethodNotAllowed)
}

serveGZip := path => (req, end) => req.method :: {
	'GET' -> readFile('static/indexes/' + path + '.gz', file => file :: {
		() -> end(NotFound)
		_ -> end({
			status: 200
			headers: {
				'Content-Type': mimeForPath(path)
				'Content-Encoding': 'gzip'
			}
			body: file
		})
	})
	_ -> end(MethodNotAllowed)
}

addRoute := server.addRoute

` static paths `
addRoute('/static/*staticPath', params => serveStatic(params.staticPath))
addRoute('/indexes/*indexPath', params => serveGZip(params.indexPath))
addRoute('/favicon.ico', params => serveStatic('favicon.ico'))
addRoute('/', params => serveStatic('index.html'))

start := () => (
	end := (server.start)(Port)
	log(f('Monocle started, listening on 0.0.0.0:{{0}}', [Port]))
)

start()


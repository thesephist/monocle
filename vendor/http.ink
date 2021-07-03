` http server abstraction `

std := load('../vendor/std')

log := std.log
f := std.format
slice := std.slice
each := std.each

auth := load('auth')
allow? := auth.allow?

route := load('route')

new := () => (
	router := (route.new)()

	` routes added to router here `

	start := port => listen('0.0.0.0:' + string(port), evt => (
		(route.catch)(router, params => (req, end) => end({
			status: 404
			body: 'service not found'
		}))

		evt.type :: {
			'error' -> log('server start error: ' + evt.message)
			'req' -> (
				log(f('{{ method }}: {{ url }}', evt.data))

				handleWithHeaders := evt => (
					handler := (route.match)(router, evt.data.url)
					handler(evt.data, resp => (
						resp.headers := hdr(resp.headers :: {
							() -> {}
							_ -> resp.headers
						})
						(evt.end)(resp)
					))
				)
				[allow?(evt.data), evt.data.method] :: {
					[true, 'GET'] -> handleWithHeaders(evt)
					[true, 'POST'] -> handleWithHeaders(evt)
					[true, 'PUT'] -> handleWithHeaders(evt)
					[true, 'DELETE'] -> handleWithHeaders(evt)
					_ -> (evt.end)({
						status: 405
						headers: hdr({})
						body: 'method not allowed'
					})
				}
			)
		}
	))

	{
		addRoute: (url, handler) => (route.add)(router, url, handler)
		start: start
	}
)

` prepare standard header `
hdr := attrs => (
	base := {
		'X-Served-By': 'ink-serve'
		'Content-Type': 'text/plain'
	}
	each(keys(attrs), k => base.(k) := attrs.(k))
	base
)

` trim query parameters `
trimQP := path => (
	max := len(path)
	(sub := (idx, acc) => idx :: {
		max -> path
		_ -> path.(idx) :: {
			'?' -> acc
			_ -> sub(idx + 1, acc + path.(idx))
		}
	})(0, '')
)

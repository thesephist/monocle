` Torus : Ink API adapter

	renderer.ink provides an Ink interface for writing web user interfaces
	against the DOM with idiomatic Ink. The renderer operates on a single
	global render tree that renders against a single root node on the page, and
	uses a light Torus-backed virtual DOM to efficiently dispatch DOM edits.

	Initialize a render tree with the Renderer constructor:

		rootEl := bind(document, 'querySelector')('#root')
		r := Renderer(rootEl)
		update := r.update

	then call update() every time the app needs to update with the new render
	tree. The renderer comes with a few helper functions, h(), ha(), and hae(),
	for making render trees ergonomic to construct with Ink.

	It is conventional to create a single object called App that instantiates a
	renderer and closes over the update function with its own Redux-style
	global state management logic that it exposes to its child elements through
	a more restricted API. `

` text nodes passed to Torus.render can't be normal Ink strings, because typeof
	<Ink string> != 'string'. We wrap Ink strings in str() here when passing to
	Torus to render strings correctly. `
str := s => bind(s, 'valueOf')(s)

` To quickly convert object-like Ink maps to arrays `
arr := bind(Object, 'values')

` Torus jdom declaration helpers `

hae := (tag, classList, attrs, events, children) => {
	tag: str(tag)
	attrs: attrs.('class') := arr(map(classList, str))
	events: events
	children: arr(map(children, child => type(child) :: {
		'string' -> str(child)
		_ -> child
	}))
}
ha := (tag, classList, attrs, children) => hae(tag, classList, attrs, {}, children)
h := (tag, classList, children) => hae(tag, classList, {}, {}, children)

` generic abstraction for a view that can be updated asynchronously `

Renderer := root => (
	render := window.Torus.render

	InitialDom := h('div', [], [])

	node := render((), (), InitialDom)
	bind(root, 'appendChild')(node)

	self := {
		node: node
		prev: InitialDom
		update: jdom => (
			self.node := render(self.node, self.prev, jdom)
			self.prev := jdom
			self.node
		)
	}
)


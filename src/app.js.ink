` Main application UI `

std := load('std')
log := std.log
f := std.format

` constants `

Newline := char(10)
MaxResultPadChars := 140 ` tweet size `

LoadedModules := []
Modules := [
	'entr'
	'lifelog'
	'ligature'
]

` utilities `

querySelector := bind(document, 'querySelector')

EscapeContainer := bind(document, 'createElement')('div')
escapeHTML := s => (
	EscapeContainer.textContent := s
	EscapeContainer.innerHTML
)
` TODO: make correct `
escapeRegExp := s => s

applyHighlights := (s, query) => (
	s := escapeHTML(s)
	queryTokens := keys(tokenize(State.query))
	replacementRegExpStr := '(^|\\W)(' + cat(escapeRegExp(queryTokens), '|') + ')'
	replacementRegExp := jsnew(RegExp, [str(replacementRegExpStr), str('ig')])

	` calling out to JavaScript's native String.prototype.replace so we
	can run a replace with a native RegExp. `
	bind(str(s), 'replaceAll')(
		replacementRegExp
		'$1<span class="search-highlight">$2</span>'
	)
)

` state and state helpers `

State := {
	query: ''
	docs: {}
	index: ()
	results: []
	selectedIdx: 0
}

fetchModuleDocs := moduleKey => (
	req := fetch(f('/indexes/{{ 0 }}.json', [moduleKey]))
	json := bind(req, 'then')(resp => bind(resp, 'json')())
	bind(json, 'then')(docs => (
		LoadedModules.len(LoadedModules) := moduleKey
		each(docs, doc => State.docs.(doc.id) := doc)
		len(LoadedModules) :: {
			len(Modules) -> (
				State.index := indexDocs(State.docs)
				render()
			)
		}
	))
)

` ui components `

SearchBox := () => h('div', ['search-box'], [
	hae(
		'input'
		['search-box-input']
		{
			value: State.query
			placeholder: 'Search...'
			autofocus: true
		}
		{
			input: evt => (
				State.query := evt.target.value
				render()

				updateResults()
			)
		}
		[]
	)
])

SearchResult := (doc, i) => h(
	'li'
	[
		'search-result'
		State.selectedIdx :: {
			i -> 'selected'
			_ -> ''
		}
	]
	[
		(
			container := bind(document, 'createElement')('div')
			container.className := 'search-result-content'
			container.onclick := evt => render(State.selectedIdx := i)
			container.innerHTML := (
				content := (MaxResultPadChars * 2 > doc.content :: {
					true -> doc.content
					` TODO: make it surround the first highlight `
					_ -> slice(doc.content, 0, MaxResultPadChars * 2)
				})

				applyHighlights(content, State.query)
			)

			container
		)
	]
)

SearchResults := () => h('div', ['search-results'], [
	h('ol', ['search-results-list'], (
		map(State.results, (result, i) => SearchResult(result, i))
	))
])

Sidebar := () => h('div', ['sidebar'], [
	SearchBox()
	State.index :: {
		() -> 'loading index...'
		_ -> ()
	}
	h('div', ['sidebar-result-stats'], [
		f('{{ 0 }} results in {{ 1 }}ms', [len(State.results), 100])
	])
	SearchResults()
])

DocPreview := () => h('div', ['doc-preview'], [
	selectedDoc := State.results.(State.selectedIdx) :: {
		() -> h('div', ['doc-preview-empty'], [
			'Select a result to view it here.'
		])
		_ -> (
			container := bind(document, 'createElement')('div')
			container.className := 'doc-preview-content'
			container.innerHTML := applyHighlights(selectedDoc.content, State.query)
			container
		)
	}
])

` state updaters `

updateResults := () => (
	` TODO: search algorithm `
	State.results := findDocs(State.index, State.docs, State.query)
	State.selectedIdx := 0
	render()
)

` main application `

root := bind(document, 'querySelector')('#root')
r := Renderer(root)
update := r.update

render := () => update(h(
	'div'
	['app']
	[
		Sidebar()
		DocPreview()
	]
))

selectDown := evt => (
	bind(evt, 'preventDefault')()
	State.selectedIdx := (State.selectedIdx + 1) % len(State.results)
	render()

	el := querySelector('.search-result.selected') :: {
		() -> ()
		_ -> bind(el, 'scrollIntoView')({block: 'nearest'})
	}
)
selectUp := evt => (
	bind(evt, 'preventDefault')()
	State.selectedIdx := (len(State.results) + State.selectedIdx - 1) % len(State.results)
	render()

	el := querySelector('.search-result.selected') :: {
		() -> ()
		_ -> bind(el, 'scrollIntoView')({block: 'nearest'})
	}
)
bind(document.body, 'addEventListener')('keydown', evt => evt.key :: {
	'Tab' -> evt.shiftKey :: {
		true -> selectUp(evt)
		_ -> selectDown(evt)
	}
	'ArrowUp' -> selectUp(evt)
	'ArrowDown' -> selectDown(evt)
	'/' -> searchBox := querySelector('.search-box-input') :: {
		() -> ()
		_ -> (
			bind(evt, 'preventDefault')()
			bind(searchBox, 'focus')()
		)
	}
})

each(Modules, fetchModuleDocs)

render()


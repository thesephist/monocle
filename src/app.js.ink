` Main application UI `

std := load('std')
log := std.log
f := std.format

` constants `

Newline := char(10)

` utilities `

querySelector := bind(document, 'querySelector')

EscapeContainer := bind(document, 'createElement')('div')
escapeHTML := s => (
	EscapeContainer.textContent := s
	EscapeContainer.innerHTML
)
` TODO: make correct `
escapeRegExp := s => s

` TODO: explain why this is needed `
fastSlice := (s, start, end) => bind(str(s), 'substring')(start, end)

clippedResultsCount := () => (
	ResultHeight := 32 ` NOTE: heuristic `
	floor((window.innerHeight - 96) / ResultHeight)
)

applyHighlights := query => (
	queryTokens := keys(tokenize(State.query))
	replacementRegExpStr := '(^|\\W)(' + cat(escapeRegExp(queryTokens), '|') + ')'
	replacementRegExp := jsnew(RegExp, [str(replacementRegExpStr), str('ig')])

	` calling out to JavaScript's native String.prototype.replace so we
	can run a replace with a native RegExp. `
	s => bind(str(escapeHTML(s)), 'replaceAll')(
		replacementRegExp
		'$1<span class="search-highlight">$2</span>'
	)
)

` state and state helpers `

State := {
	query: ''
	docs: ()
	index: ()
	results: []
	searchElapsedMs: 0
	selectedIdx: 0
	showPreview?: false
	showAllResults?: false
	theme: 'light'
}

fetchDocs := () => (
	req := fetch('/indexes/docs.json')
	json := bind(req, 'then')(resp => bind(resp, 'json')())
	bind(json, 'then')(index => render(State.docs := index))
)

fetchIndex := () => (
	req := fetch('/indexes/index.json')
	json := bind(req, 'then')(resp => bind(resp, 'json')())
	bind(json, 'then')(index => render(State.index := index))
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

SearchResult := (doc, i, highlighter, maxPreviewChars) => hae(
	'li'
	[
		'search-result'
		State.selectedIdx :: {
			i -> 'selected'
			_ -> ''
		}
	]
	{}
	{
		click: evt => (
			State.selectedIdx := i
			State.showPreview? := true
			render()
		)
	}
	[
		h('span', ['search-result-module'], [doc.module])
		doc.title :: {
			() -> ()
			_ -> h('span', ['search-result-title'], [
				doc.title
				' · '
			])
		}
		` for efficiency, we do not generate a new element every time and
		instead try to reuse elements on the page if there are any. `
		existingEl := querySelector('[data-doc-id="' + doc.id + '"]') :: {
			() -> (
				container := bind(document, 'createElement')('span')
				bind(container, 'setAttribute')('data-doc-id', doc.id)
				container.className := 'search-result-content'

				ellipsis := (len(doc.content) > maxPreviewChars :: {
					true -> '...'
					_ -> ''
				})
				container.innerHTML := highlighter(fastSlice(doc.content, 0, maxPreviewChars)) + ellipsis
				container
			)
			_ -> existingEl
		}
	]
)

SearchResults := () => h('div', ['search-results'], [
	h('ol', ['search-results-list'], (
		` NOTE: this is an arbitrary heuristic that tries to scale preview size with
		screen width, and seems to work well enough.`
		maxPreviewChars := floor(window.innerWidth / 6)
		highlighter := applyHighlights(State.query)
		results := (State.showAllResults? :: {
			true -> State.results
			_ -> slice(State.results, 0, clippedResultsCount())
		})
		map(results, (result, i) => SearchResult(
			result
			i
			highlighter
			maxPreviewChars
		))
	))
])

Sidebar := () => h('div', ['sidebar'], [
	SearchBox()
	h('div', ['sidebar-stats'], [
		State.docs = () | State.index = () :: {
			true -> 'loading index...'
			_ -> h('div', ['sidebar-result-stats'], [
				f('{{ 0 }} results ({{ 1 }}ms)', [len(State.results), State.searchElapsedMs])
			])
		}
	])
	SearchResults()
])

DocPreview := () => h('div', ['doc-preview'], [
	selectedDoc := State.results.(State.selectedIdx) :: {
		() -> h('div', ['doc-preview-empty'], [
			'Select a result to view it here.'
		])
		_ -> h('div', ['doc-preview-content'], (
			highlighter := applyHighlights(State.query)
			content := (selectedDoc.title :: {
				() -> selectedDoc.content
				_ -> selectedDoc.title + Newline + selectedDoc.content
			})
			map(split(content, Newline), para => (
				p := bind(document, 'createElement')('p')
				p.innerHTML := highlighter(para)
				p
			))
		))
	}
])

` state updaters `

updateResults := () => (
	start := time()
	State.results := findDocs(State.index, State.docs, State.query)
	State.searchElapsedMs := floor((time() - start) * 1000)
	State.selectedIdx := 0
	trim(State.query, ' ') :: {
		'' -> State.showPreview? := false
	}
	render()
)

` main application `

root := bind(document, 'querySelector')('#root')
r := Renderer(root)
update := r.update

render := () => update(h(
	'div'
	[
		'app'
	]
	[
		Sidebar()
		State.showPreview? :: {
			true -> DocPreview()
		}
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
	'Enter' -> render(State.showPreview? := true)
	'Escape' -> render(State.showPreview? := false)
	'/' -> searchBox := querySelector('.search-box-input') :: {
		() -> ()
		_ -> (
			bind(evt, 'preventDefault')()
			bind(searchBox, 'focus')()
		)
	}
	'`' -> (
		bind(evt, 'preventDefault')()
		State.theme := (State.theme :: {
			'dark' -> 'light'
			_ -> 'dark'
		})
		bind(document.body.classList, 'toggle')('dark', State.theme = 'dark')
		render()
	)
})

fetchDocs()
fetchIndex()
render()


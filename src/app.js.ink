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

EscapeRE := jsnew(RegExp, [str('[-\/\\^$*+?.()|[\]{}]'), str('g')])
escapeRegExp := s => bind(str(s), 'replace')(EscapeRE, '\\$&')

` Ink standard library's std.slice is O(n), which is normally fine because our
constant multiplier is pretty small. But when we're doing it for lots of long
strings as is the case here, we want to get down to native implementations in
the underlying JavaScript engine. `
fastSlice := (s, start, end) => bind(str(s), 'substring')(start, end)

clippedResultsCount := () => (
	ResultHeight := 32 ` NOTE: heuristic `
	floor((window.innerHeight - 96) / ResultHeight)
)

` utility for server-rendering large numbers with commas `
zeroFillTo3Digits := s => len(s) :: {
	0 -> '000'
	1 -> '00' + s
	2 -> '0' + s
	_ -> s
}
formatNumber := n => (
	sub := (acc, n) => n :: {
		0 -> acc
		_ -> sub(zeroFillTo3Digits(string(n % 1000)) + ',' + acc, floor(n / 1000))
	}

	threeDigitStr := sub(zeroFillTo3Digits(string(n % 1000)), floor(n / 1000)) :: {
		'000' -> '0'
		_ -> trimPrefix(threeDigitStr, '0')
	}
)

applyHighlights := query => (
	queryTokenVariations := tokenizeAndVary(State.query)
	replacementRegExpStr := '(^|\\W)(' + cat(map(queryTokenVariations, escapeRegExp), '|') + ')'
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

ready? := () => ~(State.docs = () | State.index = ())

fetchDocs := () => (
	req := fetch('/indexes/docs.json')
	json := bind(req, 'then')(resp => bind(resp, 'json')())
	bind(json, 'then')(docs => (
		State.docs := docs
		ready?() :: {
			true -> performSearch(State.query)
			_ -> render()
		}
	))
)

fetchIndex := () => (
	req := fetch('/indexes/index.json')
	json := bind(req, 'then')(resp => bind(resp, 'json')())
	bind(json, 'then')(index => (
		State.index := index
		ready?() :: {
			true -> performSearch(State.query)
			_ -> render()
		}
	))
)

` ui components `

Link := (text, href) => ha('a', [], {
	href: href
	target: '_blank'
}, [text])

SearchBox := () => h('div', ['search-box'], [
	hae(
		'input'
		['search-box-input']
		{
			value: State.query
			placeholder: State.docs :: {
				() -> 'Type to search...'
				_ -> 'Type to search ' + formatNumber(len(State.docs)) + ' docs'
			}
			autofocus: true
		}
		{
			input: evt => performSearch(evt.target.value)
		}
		[]
	)
	State.query :: {
		'' -> ()
		_ -> hae('button', ['search-box-clear'], {title: 'Clear search'}, {
			click: evt => performSearch('')
		}, ['×'])
	}
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

` Note that KeyboardMap is a constant, not a function like
most components, because it is static. `
KeyboardMap := h('div', ['keyboard-map'], [
	h('ul', ['keyboard-map-list'], (
		Keybindings := {
			'Tab': 'Next search result'
			'Shift Tab': 'Previous search result'
			'Enter': 'Show preview pane'
			'Escape': 'Hide preview pane, clear search'
			'/': 'Focus search box'
			'`': 'Switch light/dark color theme'
		}

		map(keys(Keybindings), keybinding => h('li', ['keyboard-map-item'], [
			h('div', ['keybinding-keys'], map(split(keybinding, ' '), key => h('kbd', [], [key])))
			h('div', ['keybinding-detail'], [Keybindings.(keybinding)])
		]))
	))
])

` Note that About is constant, rather than a function like most components,
because it is static. `
About := h('div', ['about'], [
	h('p', [], [
		'Monocle is a universal, personal search engine by '
		Link('Linus', 'https://thesephist.com')
		'. It\'s built with '
		Link('Ink', 'https://dotink.co')
		' and '
		Link('Torus', 'https://github.com/thesephist/torus')
		', and open source on '
		Link('GitHub', 'https://github.com/thesephist/monocle')
		'.'
	])
	h('p', [], [
		'Monocle is powered by a full-text indexing and search engine written in
		pure Ink, and searches across Linus\'s blogs and private note archives,
		contacts, tweets, and over a decade of journals.'
	])
])

SearchResults := () => len(State.query) = 0 :: {
	true -> h('div', ['search-results', 'search-results-empty'], [
		h('h2', ['empty-state-heading'], ['Suggestions'])
		h('div', ['search-results-suggestions'], (
			map(
				[
					'linus lee'
					'side project idea'
					'tools for thought'
					'incremental note-taking'
					'taylor swift'
					'uc berkeley'
					'new york city'
					'dorm room fund'
				]
				term => hae('button', ['search-results-suggestion'], {}, {
					click: evt => (
						performSearch(term)
						focusSearch()
					)
				}, [term])
			)
		))
		h('h2', ['empty-state-heading'], ['Keybindings'])
		KeyboardMap
		h('h2', ['empty-state-heading'], ['About Monocle'])
		About
	])
	_ -> h('div', ['search-results'], [
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
		~(State.showAllResults?) & len(State.results) > clippedResultsCount() :: {
			true -> hae('button', ['search-results-show-all'], {}, {
				click: () => render(State.showAllResults? := true)
			}, ['Show more ...'])
		}
		h('div', ['search-results-bottom-padding'], [])
	])
}

Sidebar := () => h('div', ['sidebar'], [
	SearchBox()
	h('div', ['sidebar-stats'], [
		ready?() :: {
			false -> 'loading index...'
			_ -> h('div', ['sidebar-result-stats'], [
				f('{{ 0 }} results ({{ 1 }}ms)', [len(State.results), State.searchElapsedMs])
			])
		}
	])
	SearchResults()
])

DocPreview := () => h('div', ['doc-preview'], (
	selectedDoc := State.results.(State.selectedIdx)
	[
		h('div', ['doc-preview-buttons'], [
			hae('button', ['button', 'doc-preview-close'], {title: 'Close preview'}, {
				click: evt => render(State.showPreview? := false)
			}, ['×'])
			selectedDoc :: {
				() -> ()
				_ -> href := selectedDoc.href :: {
					() -> ()
					_ -> ha('a', ['button', 'doc-preview-open'], {
						title: 'Open on new page'
						href: href
						target: '_blank'
					}, [h('span', ['desktop'], ['open ']), '→'])
				}
			}
			selectedDoc :: {
				() -> ()
				_ -> title := selectedDoc.title :: {
					() -> ()
					_ -> h('p', ['doc-preview-title'], [title])
				}
			}
		])
		selectedDoc :: {
			() -> h('div', ['doc-preview-empty'], [
				'Search & pick a result to view it here.'
			])
			_ -> h('div', ['doc-preview-content'], (
				highlighter := applyHighlights(State.query)
				nonEmptyLines := filter(
					split(selectedDoc.content, Newline)
					` shelling out to JS for performance on long docs `
					p => len(bind(str(p), 'trim')()) > 0
				)
				map(nonEmptyLines, para => (
					p := bind(document, 'createElement')('p')
					p.innerHTML := highlighter(para)
					p
				))
			))
		}
	]
))

` state updaters `

performSearch := query => ready?() :: {
	true -> (
		State.query := query

		start := time()
		State.results := findDocs(State.index, State.docs, query)
		State.searchElapsedMs := floor((time() - start) * 1000)

		State.selectedIdx := 0
		State.showAllResults? := false
		trim(query, ' ') :: {
			'' -> (
				State.showPreview? := false

				url := jsnew(URL, [location.href])
				bind(url.searchParams, 'delete')('q')
				bind(history, 'replaceState')((), (), url)

				document.title := 'Monocle'
			)
			_ -> (
				url := jsnew(URL, [location.href])
				bind(url.searchParams, 'set')('q', trim(query, ' '))
				bind(history, 'replaceState')((), (), url)

				document.title := f('"{{ query }}" | Monocle', State)
			)
		}
		render()
	)
	_ -> render(State.query := query)
}

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

focusSearch := evt => searchBox := querySelector('.search-box-input') :: {
	() -> ()
	_ -> bind(searchBox, 'focus')()
}

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
	'Enter' -> evt.ctrlKey | evt.metaKey :: {
		true -> selectedDoc := State.results.(State.selectedIdx) :: {
			() -> ()
			_ -> href := selectedDoc.href :: {
				() -> ()
				_ -> open(href, str('_blank'))
			}
		}
		_ -> render(State.showPreview? := true)
	}
	'Escape' -> State.showPreview? :: {
		true -> render(State.showPreview? := false)
		_ -> (
			performSearch('')
			focusSearch()
		)
	}
	'/' -> lower(evt.target.tagName) :: {
		'input' -> ()
		_ -> (
			bind(evt, 'preventDefault')()
			focusSearch()
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

query := bind(jsnew(URL, [location.href]).searchParams, 'get')('q') :: {
	'' -> ()
	() -> ()
	_ -> State.query := query
}

fetchDocs()
fetchIndex()

render()


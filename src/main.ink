std := load('../vendor/std')
str := load('../vendor/str')

log := std.log
scan := std.scan
map := std.map
each := std.each
append := std.append

tokenizer := load('../lib/tokenizer')
tokenize := tokenizer.tokenize
tokenFrequencyMap := tokenizer.tokenFrequencyMap

indexer := load('../lib/indexer')
indexDocs := indexer.indexDocs

searcher := load('../lib/searcher')
findDocs := searcher.findDocs

` modules `
Modules := {
	entr: load('../modules/entr')
}

` Doc : {
	id: string
	freqs: Map<string, number>
	tokens: List<string>
	getContent: () => {{ original doc }}
} `

State := {
	loadedModules: 0
}
Docs := []

each(keys(Modules), moduleKey => (
	module := Modules.(moduleKey)
	getDocs := module.getDocs
	getDocs(docs => (
		DocList := []
		each(docs, doc => (
			Docs.(doc.id) := doc
			DocList.len(DocList) := doc
		))

		State.loadedModules := State.loadedModules + 1
		State.loadedModules :: {
			len(Modules) -> (
				` TODO: clean up interfaces aorund this stuff, so we can have
				Docs as the universal argument type rather than Docs and
				DocList. `
				Index := indexDocs(DocList)

				(sub := () => (
					out('> ')
					scan(line => (
						Matches := findDocs(Index, Docs, line)
						each(Matches, doc => log((doc.getContent)()))
						sub()
					))
				))()
			)
		}
	))
))


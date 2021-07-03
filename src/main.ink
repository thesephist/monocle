std := load('../vendor/std')
str := load('../vendor/str')
json := load('../vendor/json')

log := std.log
f := std.format
scan := std.scan
map := std.map
each := std.each
append := std.append
readFile := std.readFile
writeFile := std.writeFile
split := str.split
deJSON := json.de
serJSON := json.ser

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
ModuleState := {
	loadedModules: 0
}

` Doc : {
	id: string
	tokens: Map<string, number>
} `

Docs := []

lazyGetDocs := (moduleKey, getDocs, withDocs) => readFile(f('./indexes/{{ 0 }}.json', [moduleKey]), file => file :: {
	() -> (
		log(f('[{{ 0 }}] re-generating index', [moduleKey]))
		getDocs(docs => writeFile(f('./indexes/{{ 0 }}.json', [moduleKey]), serJSON(docs), res => res :: {
			true -> withDocs(docs)
			_ -> (
				log('[main] failed to persist generated index for ' + moduleKey)
				withDocs([])
			)
		}))
	)
	_ -> withDocs(deJSON(file))
})

each(keys(Modules), moduleKey => (
	module := Modules.(moduleKey)
	getDocs := module.getDocs
	lazyGetDocs(moduleKey, getDocs, docs => (
		each(docs, doc => Docs.(doc.id) := doc)

		ModuleState.loadedModules := ModuleState.loadedModules + 1
		ModuleState.loadedModules :: {
			len(Modules) -> main(indexDocs(docs))
		}
	))
))

main := index => (sub := () => (
	out('> ')
	scan(line => (
		start := time()
		matches := findDocs(index, Docs, line)
		log(f('searched in {{ 0 }}ms', [floor((time() - start) * 1000)]))

		matches :: {
			[] -> sub()
			_ -> (
				contents := []
				each(matches, doc => (
					idParts := split(doc.id, '/')
					moduleKey := idParts.0
					moduleID := idParts.1

					(Modules.(moduleKey).getDocContent)(moduleID, content => (
						len(contents.len(contents) := content) :: {
							len(matches) -> sub(each(contents, log))
						}
					))
				))
			)
		}
	))
))()


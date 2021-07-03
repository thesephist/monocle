` Module "entr" indexes contents of linus.zone/entr from a text-based database
of quotes and ideas Linus keeps internally in Polyx (thesephist/polyx), at
EntrFilePath. `

std := load('../vendor/std')
str := load('../vendor/str')

log := std.log
slice := std.slice
map := std.map
filter := std.filter
readFile := std.readFile
split := str.split
trim := str.trim

tokenizer := load('../lib/tokenizer')
tokenize := tokenizer.tokenize
tokenFrequencyMap := tokenizer.tokenFrequencyMap

Newline := char(10)

EntrFilePath := env().HOME + '/noctd/notes/entrepreneurship-notes.md'

getDocs := withDocs => readFile(EntrFilePath, file => file :: {
	() -> (
		log('[entr] could not read entr notes file!')
		[]
	)
	_ -> (
		lines := split(file, Newline)
		nonEmptyLines := filter(lines, line => len(trim(line, ' ')) > 0)
		docs := map(nonEmptyLines, (line, i) => (
			tokens := tokenize(line)
			{
				id: 'entr/' + string(i)
				freqs: tokenFrequencyMap(tokens)
				tokens: tokens
				getContent: () => line
			}
		))
		withDocs(docs)
	)
})


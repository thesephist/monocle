` Module "lifelog" indexes contents of my journal entries, going back to 2014
when I started keeping them in my system. These entries life in a specific file
format in Polyx (thesephist/polyx)i, at LifeLogDir. `

std := load('../vendor/std')
str := load('../vendor/str')

log := std.log
slice := std.slice
map := std.map
each := std.each
filter := std.filter
append := std.append
flatten := std.flatten
readFile := std.readFile
split := str.split
trim := str.trim

tokenizer := load('../lib/tokenizer')
tokenize := tokenizer.tokenize
tokenFrequencyMap := tokenizer.tokenFrequencyMap

Newline := char(10)

LifeLogDir := env().HOME + '/noctd/notes/LifeLog/'
LifeLogFileNames := [
	'LifeLog-2019.md'
	'LifeLog-2020.md'
	'LifeLog-2021.md'
]

getDocsFromLifeLog := file => (
	lines := split(file, Newline)
	docs := map(lines, (line, i) => {
		id: 'lifelog/' + string(i)
		tokens: tokenize(line)
		content: line
	})
)

getDocs := withDocs => (
	files := []
	ifAllRead := () => len(files) :: {
		len(LifeLogFileNames) -> (
			docs := flatten(map(files, file => getDocsFromLifeLog(file)))
			withDocs(docs)
		)
	}

	each(LifeLogFileNames, fileName => readFile(LifeLogDir + fileName, file => file :: {
		() -> (
			log('[lifelog] could not read lifelog ' + fileName)
			files.len(files) := ''
			ifAllRead()
		)
		_ -> (
			files.len(files) := file
			ifAllRead()
		)
	}))
)


` Module "lifelog" indexes contents of my journal entries, going back to 2014
when I started keeping them in my system. These entries life in a specific file
format in Polyx (thesephist/polyx)i, at LifeLogDir. `

std := load('../vendor/std')
str := load('../vendor/str')

log := std.log
slice := std.slice
cat := std.cat
map := std.map
each := std.each
filter := std.filter
append := std.append
flatten := std.flatten
every := std.every
readFile := std.readFile
digit? := str.digit?
split := str.split
replace := str.replace
trim := str.trim

tokenizer := load('../lib/tokenizer')
tokenize := tokenizer.tokenize
tokenFrequencyMap := tokenizer.tokenFrequencyMap

Newline := char(10)

LifeLogDir := env().HOME + '/noctd/notes/LifeLog/'
LifeLogFileNames := [
	'LifeLog-2014.md'
	'LifeLog-2015.md'
	'LifeLog-2016.md'
	'LifeLog-2017.md'
	'LifeLog-2018.md'
	'LifeLog-2019.md'
	'LifeLog-2020.md'
	'LifeLog-2021.md'
]

entryHeader? := line => dateParts := split(split(slice(line, 0, 10), ':').0, '-') :: {
	[_, _, _] -> every(map(cat(dateParts, ''), digit?))
	_ -> false
}

getDocsFromLifeLog := file => (
	lines := split(file, Newline)

	docs := []
	each(lines, (line, i) => entryHeader?(line) :: {
		false -> ()
		_ -> entryContent := lines.(i + 2) :: {
			() -> ()
			_ -> docs.len(docs) := {
				id: 'll' + string(i)
				tokens: tokenize(line + ' ' + entryContent)
				content: Newline + replace(entryContent, ' // ', Newline)
				title: line
			}
		}
	})

	docs
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


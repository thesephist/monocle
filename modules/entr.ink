` Module "entr" indexes contents of linus.zone/entr from a text-based database
of quotes and ideas Linus keeps internally in Polyx (thesephist/polyx), at
EntrFilePath. `

std := load('../vendor/std')
str := load('../vendor/str')

log := std.log
slice := std.slice
map := std.map
each := std.each
filter := std.filter
append := std.append
readFile := std.readFile
split := str.split
trim := str.trim
hasPrefix? := str.hasPrefix?
trimPrefix := str.trimPrefix

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
		S := {
			heading: ''
			noteGroup: ''
		}

		lines := split(file, Newline)
		nonEmptyLines := filter(lines, line => len(trim(line, ' ')) > 0)

		docs := []
		each(nonEmptyLines, (line, i) => hasPrefix?(line, '#') :: {
			true -> (
				docs.len(docs) := {
					id: 'entr/' + string(i)
					tokens: tokenize(S.heading + S.noteGroup)
					content: S.noteGroup
					title: S.heading
				}
				S.heading := trimPrefix(trimPrefix(line, '#'), ' ')
				S.noteGroup := ''
			)
			_ -> S.heading :: {
				'' -> docs.len(docs) := {
					id: 'entr/' + string(i)
					tokens: tokenize(line)
					content: line
				}
				_ -> S.noteGroup := S.noteGroup + Newline + line
			}
		})
		withDocs(docs)
	)
})


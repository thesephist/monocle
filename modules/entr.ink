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
replace := str.replace
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
		` we ignore the title because the title is a false "heading" `
		contentLines := slice(nonEmptyLines, 1, len(nonEmptyLines))

		docs := []
		each(contentLines, (line, i) => hasPrefix?(line, '#') :: {
			true -> (
				docs.len(docs) := {
					id: 'entr' + string(i)
					tokens: tokenize(S.heading + S.noteGroup)
					content: replace(S.noteGroup, ' // ', Newline)
					title: S.heading
				}
				S.heading := trimPrefix(trimPrefix(line, '#'), ' ')
				S.noteGroup := ''
			)
			_ -> S.heading :: {
				'' -> hasPrefix?(line, '  ') :: {
					true -> (
						lastDoc := docs.(len(docs) - 1)
						lastDoc.content := lastDoc.content + Newline + line
					)
					_ -> docs.len(docs) := {
						id: 'entr' + string(i)
						tokens: tokenize(line)
						content: trimPrefix(replace(line, ' // ', Newline), '- ')
					}
				}
				_ -> S.noteGroup := S.noteGroup + Newline + line
			}
		})
		withDocs(docs)
	)
})


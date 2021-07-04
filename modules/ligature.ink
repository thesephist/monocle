` Module "ligature" indexes all notes in the Ligature notes app, which I use
for long-term archival notes as a part of my Polyx (thesephist/polyx) suite. `

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

LigatureDir := env().HOME + '/noctd/data/ligature'

getDocs := withDocs => dir(LigatureDir, evt => evt.type :: {
	'error' -> (
		log('[ligature] could not read the notes directory')
		withDocs([])
	)
	'data' -> (
		entries := evt.data

		` Note : [
			name: string
			content: string
		]`
		notes := []

		ifAllRead := () => len(notes) :: {
			len(entries) -> (
				docs := map(notes, note => {
					id: 'ligature/' + note.name
					tokens: tokenize(note.content)
					content: note.content
				})
				withDocs(docs)
			)
		}

		each(entries, entry => (
			readFile(LigatureDir + '/' + entry.name, file => file :: {
				() -> (
					log('[ligature] could not read note ' + entry.name)
					notes.len(notes) := {
						name: entry.name
						content: ''
					}
					ifAllRead()
				)
				_ -> (
					notes.len(notes) := {
						name: entry.name
						content: file
					}
					ifAllRead()
				)
			})
		))
	)
})

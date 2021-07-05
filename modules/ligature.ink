` Module "ligature" indexes all notes in the Ligature notes app, which I use
for long-term archival notes as a part of my Polyx (thesephist/polyx) suite. `

std := load('../vendor/std')
str := load('../vendor/str')

log := std.log
f := std.format
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
				docs := map(notes, (note, i) => (

					content := note.content
					firstNewline := (sub := i => content.(i) :: {
						() -> i
						Newline -> i
						_ -> sub(i + 1)
					})(0)

					{
						id: 'lig' + string(i)
						tokens: tokenize(content)
						content: slice(content, firstNewline, len(content))
						title: slice(content, 0, firstNewline)
						href: 'https://ligature.thesephist.com/note/' + slice(note.name, 0, len(note.name) - 3)
					}
				))
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


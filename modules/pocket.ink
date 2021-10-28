` Module "pocket" indexes entries from my read-it-later and cross-browser
bookmarking app of choice, Pocket. Rather than using the API, this module reads
from the much simpler "Export" file from under "Manage my account" menu in
Pocket's web interface, which is also available at getpocket.com/export.

The serialized Pocket export, on which this module operates, can be obtained
with the code:

JSON.stringify(Array.from(document.querySelectorAll('a')).map(a => {
    return {
        title: a.textContent,
        href: a.href,
    };
}));
`

std := load('../vendor/std')
str := load('../vendor/str')
json := load('../vendor/json')

log := std.log
slice := std.slice
cat := std.cat
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
deJSON := json.de

tokenizer := load('../lib/tokenizer')
tokenize := tokenizer.tokenize
tokenFrequencyMap := tokenizer.tokenFrequencyMap

Newline := char(10)

PocketExportPath := '/tmp/pocket-full-text.json'

getDocs := withDocs => readFile(PocketExportPath, file => file :: {
	() -> (
		log('[pocket] could not read pocket export file!')
		[]
	)
	_ -> (
		links := deJSON(file)
		docs := map(links, (link, i) => (
			i % 100 :: {
				0 -> log(string(i) + ' pages tokenized...')
			}
			{
				id: 'pk' + string(i)
				tokens: tokenize(link.title + ' ' + link.href + ' ' + link.content)
				` take the first 200 words or so, so our doc index doens't blow
				up completely in size `
				content: link.href + Newline + slice(link.content, 0, 1000)
				title: link.title
				href: link.href
			}
		))
		withDocs(docs)
	)
})


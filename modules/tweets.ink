` Module "tweets" indexes and makes searchable all of my tweets, from a Twitter
archive download. `

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

TweetsFilePath := '/tmp/tweets.json'

getDocs := withDocs => readFile(TweetsFilePath, file => file :: {
	() -> (
		log('[tweets] could not read tweet archive export file!')
		[]
	)
	_ -> (
		tweets := deJSON(file)
		docs := map(tweets, (tweet, i) => (
			i % 100 :: {
				0 -> log(string(i) + ' tweets tokenized...')
			}
			{
				id: 'tw' + string(i)
				tokens: tokenize(tweet.content)
				content: tweet.content
				href: 'https://twitter.com/thesephist/status/' + tweet.id
			}
		))
		withDocs(docs)
	)
})


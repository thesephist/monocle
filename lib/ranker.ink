` the ranker implements the popular TF-IDF (term frequency, inverse document
frequency) ranking model. Ranking functions are referenced internally by the
searcher and are not meant to be exposed outside of the library, though it can
be used outside of the library if desired -- the interface is probably stable. `

std := load('../vendor/std')
quicksort := load('../vendor/quicksort')
fastsort := load('fastsort.js')

map := std.map
reduce := std.reduce
envSortBy := (fastsort.available? :: {
	true -> fastsort.fastSortBy
	_ -> quicksort.sortBy
})

rankDocs := (matchingDocs, queryTokens, lenDocs) => envSortBy(matchingDocs, doc => (
	` if we call keys first, len call is optimized `
	lenDocTokens := len(keys(doc.tokens))

	` ranking score is the sum of TF-IDF for all terms `
	tokenScores := map(queryTokens, token => (
		termFrequency := doc.tokens.(token)
		inverseDocFrequency := ln(lenDocs / lenDocTokens)
		termFrequency * inverseDocFrequency
	))

	` sum of each term's scores `
	reduce(tokenScores, (a, b) => a - b, 0)
))


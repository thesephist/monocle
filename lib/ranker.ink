` the ranker implements a variant of the popular TF-IDF (term frequency,
inverse document frequency) ranking model. Ranking functions are referenced
internally by the searcher and are not meant to be exposed outside of the
library, though it can be used outside of the library if desired -- the
interface is probably stable. `

std := load('../vendor/std')
quicksort := load('../vendor/quicksort')
fastsort := load('fastsort.js')

map := std.map
reduce := std.reduce
envSortBy := (fastsort.available? :: {
	true -> fastsort.fastSortBy
	_ -> quicksort.sortBy
})

` rankDocs uses a slightly modified version of TF-IDF optimized for performance
and simplicity. Rather than computing the true inverse document frequency, we
simply compute log(len(docs) / len(doc)) which seems to be a useful enough
proxy that it produces correct rankings for a human judge. This lets us cut
down computational work dramatically. `
rankDocs := (matchingDocs, queryTokens, lenDocs) => envSortBy(matchingDocs, doc => reduce(
	queryTokens
	` Note that this operation will cause a runtime type error in Ink native as
	doc.tokens.(token) is potentially (), but in JS Number - null is a no-op,
	so we keep it this way as an optimization. `
	(acc, token) => acc - doc.tokens.(token)
	0
) * ln(lenDocs / len(doc.tokens)))


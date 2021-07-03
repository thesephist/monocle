` the searcher handles stemming and synonym handling `

std := load('../vendor/std')

map := std.map
slice := std.slice
filter := std.filter
reduce := std.reduce

tokenizer := load('tokenizer')
ranker := load('ranker')

tokenize := tokenizer.tokenize
rankDocs := ranker.rankDocs

includes? := (arr, it) => (sub := i => arr.(i) :: {
	it -> true
	() -> false
	_ -> sub(i + 1)
})(0)

findDocs := (index, docs, query) => (
	queryTokens := keys(tokenize(query))

	queryTokens :: {
		[] -> []
		_ -> (
			docMatches := map(
				map(queryTokens, token => index.(token))
				docIDs => docIDs :: {
					() -> []
					_ -> docIDs
				}
			)

			matchingDocIDs := reduce(
				slice(docMatches, 0, len(docMatches))
				(acc, docIDs) => filter(acc, docID => includes?(docIDs, docID))
				docMatches.0
			)

			matchingDocs := map(matchingDocIDs, id => docs.(id))

			rankDocs(matchingDocs, queryTokens)
		)
	}
)


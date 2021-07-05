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

listToSet := list => reduce(list, (acc, it) => acc.(it) := true, {})

intersectionSet := (a, b) => reduce(keys(a), (intersection, it) => b.(it) :: {
	true -> intersection.(it) := true
	_ -> intersection
}, {})

findDocs := (index, docs, query) => queryTokens := keys(tokenize(query)) :: {
	[] -> []
	_ -> (
		docMatches := map(queryTokens, token => (
			variations := variationsOfWord(token)
			variationDocSet := {}
			each(variations, var => docIDs := index.(var) :: {
				() -> ()
				_ -> each(docIDs, id => variationDocSet.(id) := true)
			})
			keys(variationDocSet)
		))

		` we perform this operation by accumulating on a set of docIDs
		rather than a list, to avoid quadratic is-element checks. `
		docMatchesAsMaps := map(docMatches, listToSet)
		matchingDocIDs := keys(reduce(
			slice(docMatchesAsMaps, 1, len(docMatchesAsMaps))
			intersectionSet
			docMatchesAsMaps.0
		))

		matchingDocs := map(matchingDocIDs, id => docs.(id))

		rankDocs(matchingDocs, tokenizeAndVary(query), len(docs))
	)
}


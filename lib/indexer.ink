` the indexer takes a map of documents to tokens, and generates a posting list
used for querying. `

std := load('../vendor/std')

each := std.each

indexDoc := (index, doc) => each(keys(doc.tokens), token => docIDs := index.(token) :: {
	() -> index.(token) := [doc.id]
	_ -> docIDs.len(docIDs) := doc.id
})

indexDocs := docs => (
	index := {}
	each(keys(docs), docID => indexDoc(index, docs.(docID)))

	index
)


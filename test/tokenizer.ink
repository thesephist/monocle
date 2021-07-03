` tokenizer tests `

tokenize := load('../lib/tokenizer').tokenize

run := (m, t) => (
	m('tokenize')
	(
		t(
			'Tokenizes lowercase words'
			tokenize('this is a short sentence')
			['short', 'sentence']
		)
		t(
			'Tokenizes sentence with mixed case'
			tokenize('This is a sentence with Proper Nouns')
			['sentence', 'proper', 'nouns']
		)
		t(
			'Tokenizes sentence with punctuation'
			tokenize('Listen! My name is -- really -- Linus Lee.')
			['listen', 'my', 'name', 'really', 'linus', 'lee']
		)
	)
)


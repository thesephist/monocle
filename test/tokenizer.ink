` tokenizer tests `

tokenize := load('../lib/tokenizer').tokenize

run := (m, t) => (
	m('tokenize')
	(
		t(
			'Tokenizes empty string to empty list'
			tokenize('')
			[]
		)
		t(
			'Tokenizes lowercase words'
			tokenize('this is a short sentence')
			{short: 1, sentence: 1}
		)
		t(
			'Tokenizes sentence with mixed case'
			tokenize('This is a sentence with Proper Nouns')
			{sentence: 1, proper: 1, nouns: 1}
		)
		t(
			'Tokenizes sentence with punctuation'
			tokenize('Listen! My name is -- really -- Linus Lee.')
			{
				listen: 1
				name: 1
				really: 1
				linus: 1
				lee: 1
			}
		)
		t(
			'Properly counts number of occurrences'
			tokenize('It won\'t be the first time we see something like this! Something crazy.')
			{
				'won\'t': 1
				first: 1
				time: 1
				see: 1
				something: 2
				crazy: 1
			}
		)
		t(
			'Skips control characters'
			tokenize('First second' + char(27) + ' ' + char(30) + ' third')
			{first: 1, second: 1, third: 1}
		)
	)
)


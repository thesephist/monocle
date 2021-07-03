runTokenizerTests := load('tokenizer').run

s := (load('../vendor/suite').suite)(
	'Bastion test suite'
)

runTokenizerTests(s.mark, s.test)

(s.end)()


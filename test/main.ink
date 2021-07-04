runTokenizerTests := load('tokenizer').run

s := (load('../vendor/suite').suite)(
	'Monocle test suite'
)

runTokenizerTests(s.mark, s.test)

(s.end)()


` the stemmer encodes stemming rules for query normalization `

std := load('../vendor/std')
str := load('../vendor/str')

filter := std.filter
hasSuffix? := str.hasSuffix?
trimSuffix := str.trimSuffix

tokenizer := load('tokenizer')
tokenize := tokenizer.tokenize

uniq := list => keys(reduce(list, (set, it) => set.(it) := true, {}))

removeRepeatedLastLetter := word => len(word) < 3 :: {
	true -> word
	_ -> word.(len(word) - 1) :: {
		word.(len(word) - 2) -> slice(word, 0, len(word) - 1)
		_ -> word
	}
}

repeatLastLetter := word => word + word.(len(word) - 1)

getStem := word => (
	stem := (true :: {
		hasSuffix?(word, 'ation') -> trimSuffix(word, 'ation') + 'e'
		hasSuffix?(word, 'tion') -> trimSuffix(word, 'tion') + 'te'
		hasSuffix?(word, 'ies') -> trimSuffix(word, 'ies') + 'y'
		hasSuffix?(word, 'ing') -> removeRepeatedLastLetter(trimSuffix(word, 'ing'))
		hasSuffix?(word, 'or') -> removeRepeatedLastLetter(trimSuffix(word, 'or')) + 'e'
		hasSuffix?(word, 'er') -> removeRepeatedLastLetter(trimSuffix(word, 'er')) + 'e'
		hasSuffix?(word, 'ed') -> removeRepeatedLastLetter(trimSuffix(word, 'ed'))
		hasSuffix?(word, 'ment') -> trimSuffix(word, 'ment')
		hasSuffix?(word, 'ly') -> trimSuffix(word, 'ly')
		hasSuffix?(word, 's') -> trimSuffix(word, 's')
		_ -> word
	})
	stem :: {
		'' -> word
		_ -> stem
	}
)

generateVariations := (word, stem) => uniq(filter([
	word

	stem
	` sometimes from tokens like "taking" we get the stem "tak", which should
	really be "take". `
	stem + 'e'
	stem + 's'
	stem + 'ly'
	stem + 'ment'
	` possessive, which does not get tokenized out because it's also often a
	contracted subject + verb pair `
	stem + '\'s'

	stem + 'ed'
	repeatLastLetter(stem) + 'ed'
	hasSuffix?(stem, 'e') :: {
		true -> stem + 'd'
		_ -> stem + 'ed'
	}

	stem + 'er'
	repeatLastLetter(stem) + 'er'
	hasSuffix?(stem, 'e') :: {
		true -> stem + 'r'
		_ -> stem + 'er'
	}

	stem + 'or'
	repeatLastLetter(stem) + 'or'
	hasSuffix?(stem, 'e') :: {
		true -> stem + 'r'
		_ -> stem + 'or'
	}

	stem + 'ing'
	repeatLastLetter(stem) + 'ing'
	hasSuffix?(stem, 'e') :: {
		true -> trimSuffix(stem, 'e') + 'ing'
		_ -> stem + 'ing'
	}

	hasSuffix?(stem, 'y') :: {
		true -> trimSuffix(stem, 'y') + 'ies'
	}
	hasSuffix?(stem, 'te') :: {
		true -> trimSuffix(stem, 'te') + 'tion'
	}
	hasSuffix?(stem, 'e') :: {
		true -> trimSuffix(stem, 'e') + 'ation'
	}
], w => ~(w = ())))

variationsOfWord := word => generateVariations(word, getStem(word))

tokenizeAndVary := s => (
	tokens := keys(tokenize(s))
	sortBy(flatten(map(tokens, variationsOfWord)), w => ~len(w))
)


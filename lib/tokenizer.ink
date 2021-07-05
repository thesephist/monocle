` the tokenizer generates a deterministic list of tokens from a given corpus,
sans common stopwords.

Many functions in this file could be written more readably, but would sacrifice
speed. Functions here, especially the ones heavy on iteration, are written with
hand-written loops for maximum performance with the standard Ink interpreter. `

std := load('../vendor/std')
str := load('../vendor/str')

f := std.format
each := std.each
reduce := std.reduce
filter := std.filter
lower := str.lower
split := str.split
lower := str.lower

Stopwords := [
	'a', 'about', 'an', 'are', 'and', 'as', 'at', 'be', 'but', 'by', 'co'
	'com', 'do', 'don\'t', 'for', 'from', 'has', 'have', 'he', 'his', 'http'
	'https', 'i', 'i\'m', 'in', 'is', 'it', 'it\'s', 'just', 'like', 'me'
	'my', 'not', 'of', 'on', 'or', 'rt', 'so', 't', 'that', 'the', 'they'
	'this', 'to', 'twitter', 'was', 'we', 'were', 'with', 'you', 'your'
]
StopwordMap := {}
each(Stopwords, word => StopwordMap.(word) := true)
notStopword? := w => StopwordMap.(w) = ()

` TODO: could be hand-unrolled into a single match expression `
Puncts := '.,:;?!#%*()[]{}\\|/<>~"-_'
punct? := c => (sub := i => Puncts.(i) :: {
	() -> false
	c -> true
	_ -> sub(i + 1)
})(0)
control? := c => point(c) < 32

` Replaces punctuations with whitespace in the given string. Note that this
function mutates its argument, and returns (). `
removePunct := s => (sub := i => c := s.(i) :: {
	() -> s
	_ -> (
		punct?(c) :: {
			true -> s.(i) := ' '
			_ -> control?(c) :: {
				true -> s.(i) := ' '
			}
		}
		sub(i + 1)
	)
})(0)

whitespace? := c => point(c) :: {
	9 -> true ` tab `
	10 -> true ` newline `
	13 -> true ` carriage return `
	32 -> true ` space `
	_ -> false
}
splitByWhitespace := s => (sub := (acc, i, sofar) => c := s.(i) :: {
	() -> sofar :: {
		'' -> acc
		_ -> acc.len(acc) := sofar
	}
	_ -> whitespace?(c) :: {
		true -> sofar :: {
			'' -> sub(acc, i + 1, '')
			_ -> sub(acc.len(acc) := sofar, i + 1, '')
		}
		_ -> c :: {
			() -> acc
			_ -> sub(acc, i + 1, sofar + c)
		}
	}
}
)([], 0, '')

tokenize := s => (
	` make a full copy of the input, since we will mutate it `
	s := '' + s
	removePunct(s)
	tokens := filter(splitByWhitespace(lower(s)), notStopword?)

	` generate a frequency map `
	reduce(tokens, (freqs, tok) => freq := freqs.(tok) :: {
		() -> freqs.(tok) := 1
		_ -> freqs.(tok) := freq + 1
	}, {})
)


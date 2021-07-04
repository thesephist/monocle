` JSON serde `

std := load('std')
str := load('str')

map := std.map
cat := std.cat

ws? := str.ws?
digit? := str.digit?

` string escape '"' `
esc := c => point(c) :: {
	9 -> '\\t'
	10 -> '\\n'
	13 -> '\\r'
	34 -> '\\"'
	92 -> '\\\\'
	_ -> c
}
escape := s => (
	max := len(s)
	(sub := (i, acc) => i :: {
		max -> acc
		_ -> sub(i + 1, acc + esc(s.(i)))
	})(0, '')
)

` composite to JSON string `
ser := c => type(c) :: {
	'()' -> 'null'
	'string' -> '"' + escape(c) + '"'
	'number' -> string(c)
	'boolean' -> string(c)
	` do not serialize functions `
	'function' -> 'null'
	'composite' -> '{' + cat(map(keys(c), k => '"' + escape(k) + '":' + ser(c.(k))), ',') + '}'
}

` is this character a numeral digit or .? `
num? := c => c :: {
	'' -> false
	'.' -> true
	_ -> digit?(c)
}

` reader implementation with internal state for deserialization `
reader := s => (
	state := {
		idx: 0
		` has there been a parse error? `
		err?: false
	}

	next := () => (
		state.idx := state.idx + 1
		c := s.(state.idx - 1) :: {
			() -> ''
			_ -> c
		}
	)

	peek := () => c := s.(state.idx) :: {
		() -> ''
		_ -> c
	}

	{
		next: next
		peek: peek
		` fast-forward through whitespace `
		ff: () => (sub := () => ws?(peek()) :: {
			true -> (
				state.idx := state.idx + 1
				sub()
			)
		})()
		done?: () => ~(state.idx < len(s))
		err: () => state.err? := true
		err?: () => state.err?
	}
)

` deserialize null `
deNull := r => (
	n := r.next
	n() + n() + n() + n() :: {
		'null' -> ()
		_ -> (r.err)()
	}
)

` deserialize string `
deString := r => (
	n := r.next
	p := r.peek

	` known to be a '"' `
	n()

	(sub := acc => p() :: {
		'' -> (
			(r.err)()
			()
		)
		'\\' -> (
			` eat backslash `
			n()
			sub(acc + (c := n() :: {
				't' -> char(9)
				'n' -> char(10)
				'r' -> char(13)
				'"' -> '"'
				_ -> c
			}))
		)
		'"' -> (
			n()
			acc
		)
		_ -> sub(acc + n())
	})('')
)

` deserialize number `
deNumber := r => (
	n := r.next
	p := r.peek
	state := {
		` have we seen a '.' yet? `
		negate?: false
		decimal?: false
	}

	p() :: {
		'-' -> (
			n()
			state.negate? := true
		)
	}

	result := (sub := acc => num?(p()) :: {
		true -> p() :: {
			'.' -> state.decimal? :: {
				true -> (r.err)()
				false -> (
					state.decimal? := true
					sub(acc + n())
				)
			}
			_ -> sub(acc + n())
		}
		false -> acc
	})('')

	state.negate? :: {
		false -> number(result)
		true -> ~number(result)
	}
)

` deserialize boolean `
deTrue := r => (
	n := r.next
	n() + n() + n() + n() :: {
		'true' -> true
		_ -> (r.err)()
	}
)
deFalse := r => (
	n := r.next
	n() + n() + n() + n() + n() :: {
		'false' -> false
		_ -> (r.err)()
	}
)

` deserialize list `
deList := r => (
	n := r.next
	p := r.peek
	ff := r.ff
	state := {
		idx: 0
	}

	` known to be a '[' `
	n()
	ff()

	(sub := acc => (r.err?)() :: {
		true -> ()
		false -> p() :: {
			'' -> (
				(r.err)()
				()
			)
			']' -> (
				n()
				acc
			)
			_ -> (
				acc.(state.idx) := der(r)
				state.idx := state.idx + 1

				ff()
				p() :: {
					',' -> n()
				}

				ff()
				sub(acc)
			)
		}
	})([])
)

` deserialize composite `
deComp := r => (
	n := r.next
	p := r.peek
	ff := r.ff

	` known to be a '{' `
	n()
	ff()

	(sub := acc => (r.err?)() :: {
		true -> ()
		false -> p() :: {
			'' -> (r.err)()
			'}' -> (
				n()
				acc
			)
			_ -> (
				key := deString(r)

				(r.err?)() :: {
					false -> (
						ff()
						p() :: {
							':' -> n()
						}

						ff()
						val := der(r)

						(r.err?)() :: {
							false -> (
								ff()
								p() :: {
									',' -> n()
								}

								ff()
								acc.(key) := val
								sub(acc)
							)
						}
					)
				}
			)
		}
	})({})
)

` JSON string in reader to composite `
der := r => (
	` trim preceding whitespace `
	(r.ff)()

	result := ((r.peek)() :: {
		'n' -> deNull(r)
		'"' -> deString(r)
		't' -> deTrue(r)
		'f' -> deFalse(r)
		'[' -> deList(r)
		'{' -> deComp(r)
		_ -> deNumber(r)
	})

	` if there was a parse error, just return null result `
	(r.err?)() :: {
		true -> ()
		false -> result
	}
)

` JSON string to composite `
de := s => der(reader(s))

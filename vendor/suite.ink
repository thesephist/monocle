` ink standard test suite tools `

std := load('std')

` borrow from std `
log := std.log
each := std.each
f := std.format

` suite constructor `
suite := label => (
	` suite data store `
	s := {
		all: 0
		passed: 0
		msgs: []
	}

	` mark sections of a test suite with human labels `
	mark := label => s.msgs.len(s.msgs) := '- ' + label

	` signal end of test suite, print out results `
	end := () => (
		log(f('suite: {{ label }}', {label: label}))
		each(s.msgs, m => log('  ' + m))
		s.passed :: {
			s.all -> log(f('ALL {{ passed }} / {{ all }} PASSED', s))
			_ -> (
				log(f('PARTIAL: {{ passed }} / {{ all }} PASSED', s))
				exit(1)
			)
		}
	)

	` log a passed test `
	onSuccess := () => (
		s.all := s.all + 1
		s.passed := s.passed + 1
	)

	` log a failed test `
	onFail := msg => (
		s.all := s.all + 1
		s.msgs.len(s.msgs) := msg
	)

	` perform a new test case `
	indent := '  ' + '  ' + '  ' + '  '
	test := (label, result, expected) => result :: {
		expected -> onSuccess()
		_ -> (
			msg := f('  * {{ label }}
{{ indent }}got {{ result }}
{{ indent }}exp {{ expected }}', {
				label: label
				result: result
				expected: expected
				indent: indent
			})
			onFail(msg)
		)
	}

	` expose API functions `
	{
		mark: mark
		test: test
		end: end
	}
)

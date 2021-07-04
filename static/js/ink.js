/**
 * Ink/JavaScript runtime/interop layer
 * implements Ink system interfaces for web and Node JS runtimes
 */

const __NODE = typeof process === 'object';

/* Ink builtins */

function args() {
	return process.argv;
}

function __ink_ident_in(cb) {
	// TODO
}

function out(s) {
	s = __as_ink_string(s);
	if (__NODE) {
		process.stdout.write(string(s).valueOf());
	} else {
		console.log(string(s).valueOf());
	}
	return null;
}

function dir(path, cb) {
	// TODO
}

function make(path, cb) {
	// TODO
}

function stat(path, cb) {
	// TODO
}

function read(path, offset, length, cb) {
	// TODO
}

function write(path, offset, data, cb) {
	// TODO
}

function __ink_ident_delete(path, cb) {
	// TODO
}

function listen(host, handler) {
	// TODO
}

function req(data, callback) {
	// TODO
}

function rand() {
	return Math.random();
}

function urand(length) {
	// TODO
}

function time() {
	return Date.now() / 1000;
}

function wait(duration, cb) {
	setTimeout(cb, duration * 1000);
	return null;
}

function exec(path, args, stdin, stdoutFn) {
	// TODO
}

function env() {
	if (__NODE) {
		return process.env;
	}
	return {};
}

function exit(code) {
	if (__NODE) {
		process.exit(code);
	}
	return null;
}

function sin(n) {
	return Math.sin(n);
}

function cos(n) {
	return Math.cos(n);
}

function asin(n) {
	return Math.asin(n);
}

function acos(n) {
	return Math.acos(n);
}

function pow(b, n) {
	return Math.pow(b, n);
}

function ln(n) {
	return Math.log(n);
}

function floor(n) {
	return Math.floor(n);
}

function load(path) {
	if (__NODE) {
		return require(string(path).valueOf());
	} else {
		throw new Error('load() not implemented!');
	}
}

function __is_ink_string(x) {
	if (x == null) {
		return false;
	}
	return x.__mark_ink_string;
}

// both JS native strings and __Ink_Strings are valid in the runtime
// semantics but we want to coerce values to __Ink_Strings
// within runtime builtins; this utility fn is useful for this.
function __as_ink_string(x) {
	if (typeof x === 'string') {
		return __Ink_String(x);
	}
	return x;
}

function string(x) {
	x = __as_ink_string(x);
	if (x === null) {
		return '()';
	} else if (typeof x === 'number') {
		return x.toString();
	} else if (__is_ink_string(x)) {
		return x;
	} else if (typeof x === 'boolean') {
		return x.toString();
	} else if (typeof x === 'function') {
		return x.toString(); // implementation-dependent, not specified
	} else if (Array.isArray(x) || typeof x === 'object') {
		const entries = [];
		for (const key of keys(x)) {
			entries.push(`${key}: ${__is_ink_string(x[key]) ? `'${x[key].valueOf().replace('\\', '\\\\').replace('\'', '\\\'')}'` : string(x[key])}`);
		}
		return '{' + entries.join(', ') + '}';
	} else if (x === undefined) {
		return 'undefined'; // undefined behavior
	}
	throw new Error('string() called on unknown type ' + x);
}

function number(x) {
	x = __as_ink_string(x);
	if (x === null) {
		return 0;
	} else if (typeof x === 'number') {
		return x;
	} else if (__is_ink_string(x)) {
		const n = parseFloat(x);
		return isNaN(n) ? null : n;
	} else if (typeof x === 'boolean') {
		return x ? 1 : 0;
	}
	return 0;
}

function point(c) {
	c = __as_ink_string(c);
	return c.valueOf().charCodeAt(0);
}

function char(n) {
	return String.fromCharCode(n);
}

function type(x) {
	x = __as_ink_string(x);
	if (x === null) {
		return '()';
	} else if (typeof x === 'number') {
		return 'number';
	} else if (__is_ink_string(x)) {
		return 'string';
	} else if (typeof x === 'boolean') {
		return 'boolean'
	} else if (typeof x === 'function') {
		return 'function';
	} else if (Array.isArray(x) || typeof x === 'object') {
		return 'composite';
	}
	throw new Error('type() called on unknown type ' + x);
}

function len(x) {
	x = __as_ink_string(x);
	switch (type(x)) {
		case 'string':
			return x.valueOf().length;
		case 'composite':
			if (Array.isArray(x)) {
				// -1 for .length
				return Object.getOwnPropertyNames(x).length - 1;
			} else {
				return Object.getOwnPropertyNames(x).length;
			}
		default:
			throw new Error('len() takes a string or composite value, but got ' + string(x));
	}
}

function keys(x) {
	if (type(x).valueOf() === 'composite') {
		if (Array.isArray(x)) {
			return Object.getOwnPropertyNames(x).filter(name => name !== 'length');
		} else {
			return Object.getOwnPropertyNames(x);
		}
	}
	throw new Error('keys() takes a composite value, but got ' + string(x).valueOf());
}

/* Ink semantics polyfill */

function __ink_negate(x) {
	if (x === true) {
		return false;
	}
	if (x === false) {
		return true;
	}

	return -x;
}

function __ink_eq(a, b) {
	a = __as_ink_string(a);
	b = __as_ink_string(b);
	if (a === __Ink_Empty || b === __Ink_Empty) {
		return true;
	}

	if (a === null && b === null) {
		return true;
	}
	if (a === null || b === null) {
		return false;
	}

	if (typeof a !== typeof b) {
		return false;
	}
	if (__is_ink_string(a) && __is_ink_string(b)) {
		return a.valueOf() === b.valueOf();
	}
	if (typeof a === 'number' || typeof a === 'boolean' || typeof a === 'function') {
		return a === b;
	}

	// deep equality check for composite types
	if (typeof a !== 'object') {
		return false;
	}
	if (len(a) !== len(b)) {
		return false;
	}
	for (const key of keys(a)) {
		if (!__ink_eq(a[key], b[key])) {
			return false;
		}
	}
	return true;
}

function __ink_and(a, b) {
	if (typeof a === 'boolean' && typeof b === 'boolean') {
		return a && b;
	}

	if (__is_ink_string(a) && __is_ink_string(b)) {
		const max = Math.max(a.length, b.length);
		const get = (s, i) => s.valueOf().charCodeAt(i) || 0;

		let res = '';
		for (let i = 0; i < max; i ++) {
			res += String.fromCharCode(get(a, i) & get(b, i));
		}
		return res;
	}

	return a & b;
}

function __ink_or(a, b) {
	if (typeof a === 'boolean' && typeof b === 'boolean') {
		return a || b;
	}

	if (__is_ink_string(a) && __is_ink_string(b)) {
		const max = Math.max(a.length, b.length);
		const get = (s, i) => s.valueOf().charCodeAt(i) || 0;

		let res = '';
		for (let i = 0; i < max; i ++) {
			res += String.fromCharCode(get(a, i) | get(b, i));
		}
		return res;
	}

	return a | b;
}

function __ink_xor(a, b) {
	if (typeof a === 'boolean' && typeof b === 'boolean') {
		return (a && !b) || (!a && b);
	}

	if (__is_ink_string(a) && __is_ink_string(b)) {
		const max = Math.max(a.length, b.length);
		const get = (s, i) => s.valueOf().charCodeAt(i) || 0;

		let res = '';
		for (let i = 0; i < max; i ++) {
			res += String.fromCharCode(get(a, i) ^ get(b, i));
		}
		return res;
	}

	return a ^ b;
}

function __ink_match(cond, clauses) {
	for (const [target, expr] of clauses) {
		if (__ink_eq(cond, target())) {
			return expr();
		}
	}
	return null;
}

/* Ink types */

const __Ink_Empty = Symbol('__Ink_Empty');

const __Ink_String = s => {
	if (__is_ink_string(s)) return s;

	return {
		__mark_ink_string: true,
		assign(i, slice) {
			if (i === s.length) {
				return s += slice;
			}

			return s = s.substr(0, i) + slice + s.substr(i + slice.length);
		},
		toString() {
			return s;
		},
		valueOf() {
			return s;
		},
		get length() {
			return s.length;
		},
	}
}

/* TCE trampoline helpers */

function __ink_resolve_trampoline(fn, ...args) {
	let rv = fn(...args);
	while (rv && rv.__is_ink_trampoline) {
		rv = rv.fn(...rv.args);
	}
	return rv;
}

function __ink_trampoline(fn, ...args) {
	return {
		__is_ink_trampoline: true,
		fn: fn,
		args: args,
	}
}

/* Ink -> JavaScript interop helpers */

const bind = (target, fn) => target[fn].bind(target);

function jsnew(Constructor, args) {
	return new Constructor(...args);
}

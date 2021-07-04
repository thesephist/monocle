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
!function(t){var e={};function s(r){if(e[r])return e[r].exports;var n=e[r]={i:r,l:!1,exports:{}};return t[r].call(n.exports,n,n.exports,s),n.l=!0,n.exports}s.m=t,s.c=e,s.d=function(t,e,r){s.o(t,e)||Object.defineProperty(t,e,{enumerable:!0,get:r})},s.r=function(t){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},s.t=function(t,e){if(1&e&&(t=s(t)),8&e)return t;if(4&e&&"object"==typeof t&&t&&t.__esModule)return t;var r=Object.create(null);if(s.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var n in t)s.d(r,n,function(e){return t[e]}.bind(null,n));return r},s.n=function(t){var e=t&&t.__esModule?function(){return t.default}:function(){return t};return s.d(e,"a",e),e},s.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},s.p="",s(s.s=0)}([function(t,e,s){const{render:r,Component:n,Styled:o,StyledComponent:i,List:c,ListOf:l,Record:a,Store:d,StoreOf:u,Router:h}=s(1),{jdom:f,css:m}=s(2);t.exports={render:r,Component:n,Styled:o,StyledComponent:i,List:c,ListOf:l,Record:a,Store:d,StoreOf:u,Router:h,jdom:f,css:m}},function(t,e,s){let r=0;const n=t=>null!==t&&"object"==typeof t,o=t=>{void 0===t.attrs&&(t.attrs={}),void 0===t.events&&(t.events={}),void 0===t.children&&(t.children=[])},i=t=>Array.isArray(t)?t:[t],c=()=>document.createComment("");let l=[];const a={replaceChild:()=>{}};const d=(t,e,s)=>{for(const r of Object.keys(t)){const n=i(t[r]),o=i(e[r]||[]);for(const t of n)o.includes(t)||"function"!=typeof t||s(r,t)}},u=(t,e,s)=>{const i=e=>{t&&t!==e&&l.push([2,t,e]),t=e};if(r++,e!==s)if(null===s)i(c());else if("string"==typeof s||"number"==typeof s)"string"==typeof e||"number"==typeof e?t.data=s:i(document.createTextNode(s));else if(void 0!==s.appendChild)i(s);else{(void 0===t||!n(e)||e&&void 0!==e.appendChild||e.tag!==s.tag)&&(e={tag:null},i(document.createElement(s.tag))),o(e),o(s);for(const r of Object.keys(s.attrs)){const n=e.attrs[r],o=s.attrs[r];if("class"===r){const e=o;Array.isArray(e)?t.className=e.join(" "):t.className=e}else if("style"===r){const e=n||{},s=o;for(const r of Object.keys(s))s[r]!==e[r]&&(t.style[r]=s[r]);for(const r of Object.keys(e))void 0===s[r]&&(t.style[r]="")}else r in t?(t[r]!==o||void 0===n&&n!==o)&&(t[r]=o):n!==o&&t.setAttribute(r,o)}for(const r of Object.keys(e.attrs))void 0===s.attrs[r]&&(r in t?t[r]=null:t.removeAttribute(r));d(s.events,e.events,(e,s)=>{t.addEventListener(e,s)}),d(e.events,s.events,(e,s)=>{t.removeEventListener(e,s)});const r=e.children,c=s.children,a=r.length,h=c.length;if(h+a>0){const n=e._nodes||[],o=a<h?a:h;let i=0;for(;i<o;i++)r[i]!==c[i]&&(n[i]=u(n[i],r[i],c[i]));if(a<h)for(;i<h;i++){const e=u(void 0,void 0,c[i]);l.push([0,t,e]),n.push(e)}else{for(;i<a;i++)l.push([1,t,n[i]]);n.splice(h,a-h)}s._nodes=n}}return 0==--r&&function(){const t=l.length;for(let e=0;e<t;e++){const t=l[e],s=t[0];if(1===s)t[1].removeChild(t[2]);else if(2===s){const e=t[1],s=c(),r=e.parentNode;null!==r?(r.replaceChild(s,e),t[1]=s,t[3]=r):t[3]=a}}for(let e=0;e<t;e++){const t=l[e],s=t[0];0===s?t[1].appendChild(t[2]):2===s&&t[3].replaceChild(t[2],t[1])}l=[]}(),t};class h{constructor(...t){this.jdom=void 0,this.node=void 0,this.event={source:null,handler:()=>{}},this.init(...t),void 0===this.node&&this.render()}static from(t){return class extends h{init(...t){this.args=t}compose(){return t(...this.args)}}}init(){}get record(){return this.event.source}bind(t,e){if(this.unbind(),!(t instanceof j))throw new Error(`cannot bind to ${t}, which is not an instance of Evented.`);this.event={source:t,handler:e},t.addHandler(e)}unbind(){this.record&&this.record.removeHandler(this.event.handler),this.event={source:null,handler:()=>{}}}remove(){this.unbind()}compose(){return null}preprocess(t){return t}render(t){t=t||this.record&&this.record.summarize();const e=this.preprocess(this.compose(t),t);if(void 0===e)throw new Error(this.constructor.name+".compose() returned undefined.");try{this.node=u(this.node,this.jdom,e)}catch(t){console.error("rendering error.",t)}return this.jdom=e}}const f=new Set;let m;const p=new WeakMap,v=(t,e)=>t+"{"+e+"}",b=(t,e)=>{let s=[],r="";for(const n of Object.keys(e)){const o=e[n];if("@"===n[0])n.startsWith("@media")?s.push(v(n,b(t,o).join(""))):s.push(v(n,b("",o).join("")));else if("object"==typeof o){const e=n.split(",");for(const r of e)if(r.includes("&")){const e=r.replace(/&/g,t);s=s.concat(b(e,o))}else s=s.concat(b(t+" "+r,o))}else r+=n+":"+o+";"}return r&&s.unshift(v(t,r)),s},g=t=>{const e=(t=>{if(!p.has(t)){const e=JSON.stringify(t);let s=e.length,r=1989;for(;s;)r=13*r^e.charCodeAt(--s);p.set(t,"_torus"+(r>>>0))}return p.get(t)})(t);let s=0;if(!f.has(e)){m||(()=>{const t=document.createElement("style");t.setAttribute("data-torus",""),document.head.appendChild(t),m=t.sheet})();const r=b("."+e,t);for(const t of r)m.insertRule(t,s++);f.add(e)}return e},y=t=>class extends t{styles(){return{}}preprocess(t,e){return n(t)&&(t.attrs=t.attrs||{},t.attrs.class=i(t.attrs.class||[]),t.attrs.class.push(g(this.styles(e)))),t}};class x extends h{get itemClass(){return h}init(t,...e){this.store=t,this.items=new Map,this.filterFn=null,this.itemData=e,this.bind(this.store,()=>this.itemsChanged())}itemsChanged(){const t=this.store.summarize(),e=this.items;for(const s of e.keys())t.includes(s)||(e.get(s).remove(),e.delete(s));for(const s of t)e.has(s)||e.set(s,new this.itemClass(s,()=>this.store.remove(s),...this.itemData));let s=[...e.entries()];null!==this.filterFn&&(s=s.filter(t=>this.filterFn(t[0]))),s.sort((e,s)=>t.indexOf(e[0])-t.indexOf(s[0])),this.items=new Map(s),this.render()}filter(t){this.filterFn=t,this.itemsChanged()}unfilter(){this.filterFn=null,this.itemsChanged()}get components(){return[...this]}get nodes(){return this.components.map(t=>t.node)}[Symbol.iterator](){return this.items.values()}remove(){super.remove();for(const t of this.items.values())t.remove()}compose(){return{tag:"ul",children:this.nodes}}}class j{constructor(){this.handlers=new Set}summarize(){}emitEvent(){const t=this.summarize();for(const e of this.handlers)e(t)}addHandler(t){this.handlers.add(t),t(this.summarize())}removeHandler(t){this.handlers.delete(t)}}class w extends j{constructor(t,e={}){super(),n(t)&&(e=t,t=null),this.id=t,this.data=e}update(t){Object.assign(this.data,t),this.emitEvent()}get(t){return this.data[t]}summarize(){return Object.assign({id:this.id},this.data)}serialize(){return this.summarize()}}class O extends j{constructor(t=[]){super(),this.reset(t)}get recordClass(){return w}get comparator(){return null}create(t,e){return this.add(new this.recordClass(t,e))}add(t){return this.records.add(t),this.emitEvent(),t}remove(t){return this.records.delete(t),this.emitEvent(),t}[Symbol.iterator](){return this.records.values()}find(t){for(const e of this.records)if(e.id===t)return e;return null}reset(t){this.records=new Set(t),this.emitEvent()}summarize(){return[...this.records].map(t=>[this.comparator?this.comparator(t):null,t]).sort((t,e)=>t[0]<e[0]?-1:t[0]>e[0]?1:0).map(t=>t[1])}serialize(){return this.summarize().map(t=>t.serialize())}}const C=t=>{let e;const s=[];for(;null!==e;)if(e=/:\w+/.exec(t),e){const r=e[0];s.push(r.substr(1)),t=t.replace(r,"(.+)")}return[new RegExp(t),s]};const S={render:u,Component:h,Styled:y,StyledComponent:y(h),List:x,ListOf:t=>class extends x{get itemClass(){return t}},Record:w,Store:O,StoreOf:t=>class extends O{get recordClass(){return t}},Router:class extends j{constructor(t){super(),this.routes=Object.entries(t).map(([t,e])=>[t,...C(e)]),this.lastMatch=["",null],this._cb=()=>this.route(location.pathname),window.addEventListener("popstate",this._cb),this._cb()}summarize(){return this.lastMatch}go(t,{replace:e=!1}={}){window.location.pathname!==t&&(e?history.replaceState(null,document.title,t):history.pushState(null,document.title,t),this.route(t))}route(t){for(const[e,s,r]of this.routes){const n=s.exec(t);if(null!==n){const t={},s=n.slice(1);r.forEach((e,r)=>t[e]=s[r]),this.lastMatch=[e,t];break}}this.emitEvent()}remove(){window.removeEventListener("popstate",this._cb)}}};"object"==typeof window&&(window.Torus=S),t.exports&&(t.exports=S)},function(t,e,s){const r=t=>null!==t&&"object"==typeof t,n=(t,e)=>t.substr(0,t.length-e.length),o=(t,e)=>{let s=t[0];for(let r=1,n=e.length;r<=n;r++)s+=e[r-1]+t[r];return s};class i{constructor(t){this.idx=0,this.content=t,this.len=t.length}next(){const t=this.content[this.idx++];return void 0===t&&(this.idx=this.len),t}back(){this.idx--}readUpto(t){const e=this.content.substr(this.idx).indexOf(t);return this.toNext(e)}readUntil(t){const e=this.content.substr(this.idx).indexOf(t)+t.length;return this.toNext(e)}toNext(t){const e=this.content.substr(this.idx);if(-1===t)return this.idx=this.len,e;{const s=e.substr(0,t);return this.idx+=t,s}}clipEnd(t){return!!this.content.endsWith(t)&&(this.content=n(this.content,t),!0)}}const c=t=>{let e="";for(let s=0,r=t.length;s<r;s++)e+="-"===t[s]?t[++s].toUpperCase():t[s];return e},l=t=>{if("!"===(t=t.trim())[0])return{jdom:null,selfClosing:!0};if(!t.includes(" ")){const e=t.endsWith("/");return{jdom:{tag:e?n(t,"/"):t,attrs:{},events:{}},selfClosing:e}}const e=new i(t),s=e.clipEnd("/");let r="",o=!1,l=!1;const a=[];let d=0;const u=t=>{r=r.trim(),(""!==r||t)&&(a.push({type:d,value:r}),o=!1,r="")};for(let t=e.next();void 0!==t;t=e.next())switch(t){case"=":l?r+=t:(u(),o=!0,d=1);break;case" ":l?r+=t:o||(u(),d=0);break;case"\\":l&&(t=e.next(),r+=t);break;case'"':l?(l=!1,u(!0),d=0):1===d&&(l=!0);break;default:r+=t,o=!1}u();let h="";const f={},m={};h=a.shift().value;let p=null,v=a.shift();const b=()=>{p=v,v=a.shift()};for(;void 0!==v;){if(1===v.type){const t=p.value;let e=v.value.trim();if(t.startsWith("on"))m[t.substr(2)]=[e];else if("class"===t)""!==e&&(f[t]=e.split(" "));else if("style"===t){e.endsWith(";")&&(e=e.substr(0,e.length-1));const s={};for(const t of e.split(";")){const e=t.indexOf(":"),r=t.substr(0,e),n=t.substr(e+1);s[c(r.trim())]=n.trim()}f[t]=s}else f[t]=e;b()}else p&&(f[p.value]=!0);b()}return p&&0===p.type&&(f[p.value]=!0),{jdom:{tag:h,attrs:f,events:m},selfClosing:s}},a=t=>{const e=[];let s=null,r=!1;const n=()=>{r&&""===s.trim()||s&&e.push(s),s=null,r=!1},o=t=>{!1===r&&(n(),r=!0,s=""),s+=t};for(let e=t.next();void 0!==e;e=t.next())if("<"===e){if(n(),"/"===t.next()){t.readUntil(">");break}{t.back();const e=l(t.readUpto(">"));t.next(),s=e&&e.jdom,e.selfClosing||null===s||(s.children=a(t))}}else o("&"===e?(i=e+t.readUntil(";"),String.fromCodePoint(+/&#(\w+);/.exec(i)[1])):e);var i;return n(),e},d=new Map,u=/jdom_tpl_obj_\[(\d+)\]/,h=(t,e)=>{if((t=>"string"==typeof t&&t.includes("jdom_tpl_"))(t)){const s=u.exec(t),r=t.split(s[0]),n=s[1],o=h(r[1],e);let i=[];return""!==r[0]&&i.push(r[0]),Array.isArray(e[n])?i=i.concat(e[n]):i.push(e[n]),0!==o.length&&(i=i.concat(o)),i}return""!==t?[t]:[]},f=(t,e)=>{const s=[];for(const n of t)for(const t of h(n,e))r(t)&&v(t,e),s.push(t);const n=s[0],o=s[s.length-1];return"string"==typeof n&&""===n.trim()&&s.shift(),"string"==typeof o&&""===o.trim()&&s.pop(),s},m=(t,e)=>{if(t.length<14)return t;{const s=u.exec(t);if(null===s)return t;if(t.trim()===s[0])return e[s[1]];{const r=t.split(s[0]);return r[0]+e[s[1]]+m(r[1],e)}}},p=(t,e)=>{for(let s=0,r=t.length;s<r;s++){const r=t[s];"string"==typeof r?t[s]=m(r,e):Array.isArray(r)?p(r,e):v(r,e)}},v=(t,e)=>{if(!(t instanceof Node))for(const s of Object.keys(t)){const n=t[s];"string"==typeof n?t[s]=m(n,e):Array.isArray(n)?"children"===s?t.children=f(n,e):p(n,e):r(n)&&v(n,e)}},b=t=>{const e={};let s=0,r=["",""];const n=()=>{"string"==typeof r[1]?e[r[0].trim()]=r[1].trim():e[r[0].trim()]=r[1],r=["",""]};t.readUntil("{");for(let e=t.next();void 0!==e&&"}"!==e;e=t.next()){const o=r[0];switch(e){case'"':case"'":for(r[s]+=e+t.readUntil(e);r[s].endsWith("\\"+e);)r[s]+=t.readUntil(e);break;case":":""===o.trim()||o.includes("&")||o.includes("@")||o.includes(":")?r[s]+=e:s=1;break;case";":s=0,n();break;case"{":t.back(),r[1]=b(t),n();break;default:r[s]+=e}}return""!==r[0].trim()&&n(),e},g=new Map,y={jdom:(t,...e)=>{const s=t.join("jdom_tpl_joiner");try{if(!d.has(s)){const r=e.map((t,e)=>`jdom_tpl_obj_[${e}]`),n=new i(o(t.map(t=>t.replace(/\s+/g," ")),r)),c=a(n)[0],l=typeof c,u=JSON.stringify(c);d.set(s,t=>{if("string"===l)return m(c,t);if("object"===l){const e={},s=JSON.parse(u);return v(Object.assign(e,s),t),e}return null})}return d.get(s)(e)}catch(s){return console.error(`jdom parse error.\ncheck for mismatched brackets, tags, quotes.\n${o(t,e)}\n${s.stack||s}`),""}},css:(t,...e)=>{const s=o(t,e).trim();return g.has(s)||g.set(s,b(new i("{"+s+"}"))),g.get(s)}};"object"==typeof window&&Object.assign(window,y),t.exports&&(t.exports=y)}]);
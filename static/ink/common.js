str = s => bind(s, __Ink_String(`valueOf`))(s);
arr = bind(Object, __Ink_String(`values`));
hae = (tag, classList, attrs, events, children) => ({tag: str(tag), attrs: (() => {let __ink_assgn_trgt = __as_ink_string(attrs); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign((() => { return __Ink_String(`class`) })(), arr(map(classList, str))) : (__ink_assgn_trgt[(() => { return __Ink_String(`class`) })()]) = arr(map(classList, str)); return __ink_assgn_trgt})(), events: events, children: arr(map(children, child => __ink_match(type(child), [[() => (__Ink_String(`string`)), () => (str(child))], [() => (__Ink_Empty), () => (child)]])))});
ha = (tag, classList, attrs, children) => hae(tag, classList, attrs, {}, children);
h = (tag, classList, children) => hae(tag, classList, {}, {}, children);
Renderer = root => (() => { let InitialDom; let node; let render; let self; render = (() => {let __ink_acc_trgt = __as_ink_string((() => {let __ink_acc_trgt = __as_ink_string(window); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[Torus] || null : (__ink_acc_trgt.Torus !== undefined ? __ink_acc_trgt.Torus : null)})()); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[render] || null : (__ink_acc_trgt.render !== undefined ? __ink_acc_trgt.render : null)})(); InitialDom = h(__Ink_String(`div`), [], []); node = render(null, null, InitialDom); bind(root, __Ink_String(`appendChild`))(node); return self = {node: node, prev: InitialDom, update: jdom => (() => { (() => {let __ink_assgn_trgt = __as_ink_string(self); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(node, render((() => {let __ink_acc_trgt = __as_ink_string(self); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[node] || null : (__ink_acc_trgt.node !== undefined ? __ink_acc_trgt.node : null)})(), (() => {let __ink_acc_trgt = __as_ink_string(self); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[prev] || null : (__ink_acc_trgt.prev !== undefined ? __ink_acc_trgt.prev : null)})(), jdom)) : (__ink_assgn_trgt.node) = render((() => {let __ink_acc_trgt = __as_ink_string(self); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[node] || null : (__ink_acc_trgt.node !== undefined ? __ink_acc_trgt.node : null)})(), (() => {let __ink_acc_trgt = __as_ink_string(self); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[prev] || null : (__ink_acc_trgt.prev !== undefined ? __ink_acc_trgt.prev : null)})(), jdom); return __ink_assgn_trgt})(); (() => {let __ink_assgn_trgt = __as_ink_string(self); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(prev, jdom) : (__ink_assgn_trgt.prev) = jdom; return __ink_assgn_trgt})(); return (() => {let __ink_acc_trgt = __as_ink_string(self); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[node] || null : (__ink_acc_trgt.node !== undefined ? __ink_acc_trgt.node : null)})() })()} })()

std = load(__Ink_String(`std`));
log = (() => {let __ink_acc_trgt = __as_ink_string(std); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[log] || null : (__ink_acc_trgt.log !== undefined ? __ink_acc_trgt.log : null)})();
f = (() => {let __ink_acc_trgt = __as_ink_string(std); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[format] || null : (__ink_acc_trgt.format !== undefined ? __ink_acc_trgt.format : null)})();
Newline = char(10);
LoadedModules = [];
Modules = [__Ink_String(`www`), __Ink_String(`entr`), __Ink_String(`mira`), __Ink_String(`lifelog`), __Ink_String(`ligature`), __Ink_String(`ideaflow`)];
querySelector = bind(document, __Ink_String(`querySelector`));
EscapeContainer = bind(document, __Ink_String(`createElement`))(__Ink_String(`div`));
escapeHTML = s => (() => { (() => {let __ink_assgn_trgt = __as_ink_string(EscapeContainer); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(textContent, s) : (__ink_assgn_trgt.textContent) = s; return __ink_assgn_trgt})(); return (() => {let __ink_acc_trgt = __as_ink_string(EscapeContainer); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[innerHTML] || null : (__ink_acc_trgt.innerHTML !== undefined ? __ink_acc_trgt.innerHTML : null)})() })();
escapeRegExp = s => s;
fastSlice = (s, start, end) => bind(str(s), __Ink_String(`substring`))(start, end);
clippedResultsCount = () => (() => { let ResultHeight; ResultHeight = 32; return floor(((() => { return ((() => {let __ink_acc_trgt = __as_ink_string(window); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[innerHeight] || null : (__ink_acc_trgt.innerHeight !== undefined ? __ink_acc_trgt.innerHeight : null)})() - 96) })() / ResultHeight)) })();
applyHighlights = query => (() => { let queryTokens; let replacementRegExp; let replacementRegExpStr; queryTokens = keys(tokenize((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[query] || null : (__ink_acc_trgt.query !== undefined ? __ink_acc_trgt.query : null)})())); replacementRegExpStr = __as_ink_string(__as_ink_string(__Ink_String(`(^|\\W)(`) + cat(escapeRegExp(queryTokens), __Ink_String(`|`))) + __Ink_String(`)`)); replacementRegExp = jsnew(RegExp, [str(replacementRegExpStr), str(__Ink_String(`ig`))]); return s => bind(str(escapeHTML(s)), __Ink_String(`replaceAll`))(replacementRegExp, __Ink_String(`$1<span class="search-highlight">$2</span>`)) })();
State = {query: __Ink_String(``), docs: {}, index: null, results: [], searchElapsedMs: 0, selectedIdx: 0, showPreview__ink_qm__: false, showAllResults__ink_qm__: false, theme: __Ink_String(`light`)};
fetchModuleDocs = moduleKey => (() => { let json; let req; req = fetch(f(__Ink_String(`/indexes/{{ 0 }}.json`), [moduleKey])); json = bind(req, __Ink_String(`then`))(resp => bind(resp, __Ink_String(`json`))()); return bind(json, __Ink_String(`then`))(docs => (() => { (() => {let __ink_assgn_trgt = __as_ink_string(LoadedModules); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(len(LoadedModules), moduleKey) : (__ink_assgn_trgt[len(LoadedModules)]) = moduleKey; return __ink_assgn_trgt})(); each(docs, doc => (() => {let __ink_assgn_trgt = __as_ink_string((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[docs] || null : (__ink_acc_trgt.docs !== undefined ? __ink_acc_trgt.docs : null)})()); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign((() => { return (() => {let __ink_acc_trgt = __as_ink_string(doc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[id] || null : (__ink_acc_trgt.id !== undefined ? __ink_acc_trgt.id : null)})() })(), (() => { return (() => {let __ink_assgn_trgt = __as_ink_string(doc); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(module, moduleKey) : (__ink_assgn_trgt.module) = moduleKey; return __ink_assgn_trgt})() })()) : (__ink_assgn_trgt[(() => { return (() => {let __ink_acc_trgt = __as_ink_string(doc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[id] || null : (__ink_acc_trgt.id !== undefined ? __ink_acc_trgt.id : null)})() })()]) = (() => { return (() => {let __ink_assgn_trgt = __as_ink_string(doc); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(module, moduleKey) : (__ink_assgn_trgt.module) = moduleKey; return __ink_assgn_trgt})() })(); return __ink_assgn_trgt})()); return __ink_match(len(LoadedModules), [[() => (len(Modules)), () => ((() => { let start; start = time(); (() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(index, indexDocs((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[docs] || null : (__ink_acc_trgt.docs !== undefined ? __ink_acc_trgt.docs : null)})())) : (__ink_assgn_trgt.index) = indexDocs((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[docs] || null : (__ink_acc_trgt.docs !== undefined ? __ink_acc_trgt.docs : null)})()); return __ink_assgn_trgt})(); return render() })())]]) })()) })();
SearchBox = () => h(__Ink_String(`div`), [__Ink_String(`search-box`)], [hae(__Ink_String(`input`), [__Ink_String(`search-box-input`)], {value: (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[query] || null : (__ink_acc_trgt.query !== undefined ? __ink_acc_trgt.query : null)})(), placeholder: __Ink_String(`Search...`), autofocus: true}, {input: evt => (() => { (() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(query, (() => {let __ink_acc_trgt = __as_ink_string((() => {let __ink_acc_trgt = __as_ink_string(evt); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[target] || null : (__ink_acc_trgt.target !== undefined ? __ink_acc_trgt.target : null)})()); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[value] || null : (__ink_acc_trgt.value !== undefined ? __ink_acc_trgt.value : null)})()) : (__ink_assgn_trgt.query) = (() => {let __ink_acc_trgt = __as_ink_string((() => {let __ink_acc_trgt = __as_ink_string(evt); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[target] || null : (__ink_acc_trgt.target !== undefined ? __ink_acc_trgt.target : null)})()); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[value] || null : (__ink_acc_trgt.value !== undefined ? __ink_acc_trgt.value : null)})(); return __ink_assgn_trgt})(); render(); return updateResults() })()}, [])]);
SearchResult = (doc, i, highlighter, maxPreviewChars) => (() => { let existingEl; return hae(__Ink_String(`li`), [__Ink_String(`search-result`), __ink_match((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[selectedIdx] || null : (__ink_acc_trgt.selectedIdx !== undefined ? __ink_acc_trgt.selectedIdx : null)})(), [[() => (i), () => (__Ink_String(`selected`))], [() => (__Ink_Empty), () => (__Ink_String(``))]])], {}, {click: evt => (() => { (() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(selectedIdx, i) : (__ink_assgn_trgt.selectedIdx) = i; return __ink_assgn_trgt})(); (() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(showPreview__ink_qm__, true) : (__ink_assgn_trgt.showPreview__ink_qm__) = true; return __ink_assgn_trgt})(); return render() })()}, [h(__Ink_String(`span`), [__Ink_String(`search-result-module`)], [(() => {let __ink_acc_trgt = __as_ink_string(doc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[module] || null : (__ink_acc_trgt.module !== undefined ? __ink_acc_trgt.module : null)})()]), __ink_match((() => {let __ink_acc_trgt = __as_ink_string(doc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[title] || null : (__ink_acc_trgt.title !== undefined ? __ink_acc_trgt.title : null)})(), [[() => (null), () => (null)], [() => (__Ink_Empty), () => (h(__Ink_String(`span`), [__Ink_String(`search-result-title`)], [(() => {let __ink_acc_trgt = __as_ink_string(doc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[title] || null : (__ink_acc_trgt.title !== undefined ? __ink_acc_trgt.title : null)})(), __Ink_String(` · `)]))]]), __ink_match(existingEl = querySelector(__as_ink_string(__as_ink_string(__Ink_String(`[data-doc-id="`) + (() => {let __ink_acc_trgt = __as_ink_string(doc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[id] || null : (__ink_acc_trgt.id !== undefined ? __ink_acc_trgt.id : null)})()) + __Ink_String(`"]`))), [[() => (null), () => ((() => { let container; let ellipsis; container = bind(document, __Ink_String(`createElement`))(__Ink_String(`span`)); bind(container, __Ink_String(`setAttribute`))(__Ink_String(`data-doc-id`), (() => {let __ink_acc_trgt = __as_ink_string(doc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[id] || null : (__ink_acc_trgt.id !== undefined ? __ink_acc_trgt.id : null)})()); (() => {let __ink_assgn_trgt = __as_ink_string(container); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(className, __Ink_String(`search-result-content`)) : (__ink_assgn_trgt.className) = __Ink_String(`search-result-content`); return __ink_assgn_trgt})(); ellipsis = (() => { return __ink_match((len((() => {let __ink_acc_trgt = __as_ink_string(doc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[content] || null : (__ink_acc_trgt.content !== undefined ? __ink_acc_trgt.content : null)})()) > maxPreviewChars), [[() => (true), () => (__Ink_String(`...`))], [() => (__Ink_Empty), () => (__Ink_String(``))]]) })(); (() => {let __ink_assgn_trgt = __as_ink_string(container); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(innerHTML, __as_ink_string(highlighter(fastSlice((() => {let __ink_acc_trgt = __as_ink_string(doc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[content] || null : (__ink_acc_trgt.content !== undefined ? __ink_acc_trgt.content : null)})(), 0, maxPreviewChars)) + ellipsis)) : (__ink_assgn_trgt.innerHTML) = __as_ink_string(highlighter(fastSlice((() => {let __ink_acc_trgt = __as_ink_string(doc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[content] || null : (__ink_acc_trgt.content !== undefined ? __ink_acc_trgt.content : null)})(), 0, maxPreviewChars)) + ellipsis); return __ink_assgn_trgt})(); return container })())], [() => (__Ink_Empty), () => (existingEl)]])]) })();
SearchResults = () => h(__Ink_String(`div`), [__Ink_String(`search-results`)], [h(__Ink_String(`ol`), [__Ink_String(`search-results-list`)], (() => { let highlighter; let maxPreviewChars; let results; maxPreviewChars = floor(((() => {let __ink_acc_trgt = __as_ink_string(window); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[innerWidth] || null : (__ink_acc_trgt.innerWidth !== undefined ? __ink_acc_trgt.innerWidth : null)})() / 6)); highlighter = applyHighlights((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[query] || null : (__ink_acc_trgt.query !== undefined ? __ink_acc_trgt.query : null)})()); results = (() => { return __ink_match((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[showAllResults__ink_qm__] || null : (__ink_acc_trgt.showAllResults__ink_qm__ !== undefined ? __ink_acc_trgt.showAllResults__ink_qm__ : null)})(), [[() => (true), () => ((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[results] || null : (__ink_acc_trgt.results !== undefined ? __ink_acc_trgt.results : null)})())], [() => (__Ink_Empty), () => (slice((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[results] || null : (__ink_acc_trgt.results !== undefined ? __ink_acc_trgt.results : null)})(), 0, clippedResultsCount()))]]) })(); return map(results, (result, i) => SearchResult(result, i, highlighter, maxPreviewChars)) })())]);
Sidebar = () => h(__Ink_String(`div`), [__Ink_String(`sidebar`)], [SearchBox(), h(__Ink_String(`div`), [__Ink_String(`sidebar-stats`)], [__ink_match((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[index] || null : (__ink_acc_trgt.index !== undefined ? __ink_acc_trgt.index : null)})(), [[() => (null), () => (__Ink_String(`loading index...`))], [() => (__Ink_Empty), () => (h(__Ink_String(`div`), [__Ink_String(`sidebar-result-stats`)], [f(__Ink_String(`{{ 0 }} results ({{ 1 }}ms)`), [len((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[results] || null : (__ink_acc_trgt.results !== undefined ? __ink_acc_trgt.results : null)})()), (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[searchElapsedMs] || null : (__ink_acc_trgt.searchElapsedMs !== undefined ? __ink_acc_trgt.searchElapsedMs : null)})()])]))]])]), SearchResults()]);
DocPreview = () => (() => { let selectedDoc; return h(__Ink_String(`div`), [__Ink_String(`doc-preview`)], [__ink_match(selectedDoc = (() => {let __ink_acc_trgt = __as_ink_string((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[results] || null : (__ink_acc_trgt.results !== undefined ? __ink_acc_trgt.results : null)})()); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[(() => { return (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[selectedIdx] || null : (__ink_acc_trgt.selectedIdx !== undefined ? __ink_acc_trgt.selectedIdx : null)})() })()] || null : (__ink_acc_trgt[(() => { return (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[selectedIdx] || null : (__ink_acc_trgt.selectedIdx !== undefined ? __ink_acc_trgt.selectedIdx : null)})() })()] !== undefined ? __ink_acc_trgt[(() => { return (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[selectedIdx] || null : (__ink_acc_trgt.selectedIdx !== undefined ? __ink_acc_trgt.selectedIdx : null)})() })()] : null)})(), [[() => (null), () => (h(__Ink_String(`div`), [__Ink_String(`doc-preview-empty`)], [__Ink_String(`Select a result to view it here.`)]))], [() => (__Ink_Empty), () => (h(__Ink_String(`div`), [__Ink_String(`doc-preview-content`)], (() => { let content; let highlighter; highlighter = applyHighlights((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[query] || null : (__ink_acc_trgt.query !== undefined ? __ink_acc_trgt.query : null)})()); content = (() => { return __ink_match((() => {let __ink_acc_trgt = __as_ink_string(selectedDoc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[title] || null : (__ink_acc_trgt.title !== undefined ? __ink_acc_trgt.title : null)})(), [[() => (null), () => ((() => {let __ink_acc_trgt = __as_ink_string(selectedDoc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[content] || null : (__ink_acc_trgt.content !== undefined ? __ink_acc_trgt.content : null)})())], [() => (__Ink_Empty), () => (__as_ink_string(__as_ink_string((() => {let __ink_acc_trgt = __as_ink_string(selectedDoc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[title] || null : (__ink_acc_trgt.title !== undefined ? __ink_acc_trgt.title : null)})() + Newline) + (() => {let __ink_acc_trgt = __as_ink_string(selectedDoc); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[content] || null : (__ink_acc_trgt.content !== undefined ? __ink_acc_trgt.content : null)})()))]]) })(); return map(split(content, Newline), para => (() => { let p; p = bind(document, __Ink_String(`createElement`))(__Ink_String(`p`)); (() => {let __ink_assgn_trgt = __as_ink_string(p); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(innerHTML, highlighter(para)) : (__ink_assgn_trgt.innerHTML) = highlighter(para); return __ink_assgn_trgt})(); return p })()) })()))]])]) })();
updateResults = () => (() => { let start; start = time(); (() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(results, findDocs((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[index] || null : (__ink_acc_trgt.index !== undefined ? __ink_acc_trgt.index : null)})(), (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[docs] || null : (__ink_acc_trgt.docs !== undefined ? __ink_acc_trgt.docs : null)})(), (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[query] || null : (__ink_acc_trgt.query !== undefined ? __ink_acc_trgt.query : null)})())) : (__ink_assgn_trgt.results) = findDocs((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[index] || null : (__ink_acc_trgt.index !== undefined ? __ink_acc_trgt.index : null)})(), (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[docs] || null : (__ink_acc_trgt.docs !== undefined ? __ink_acc_trgt.docs : null)})(), (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[query] || null : (__ink_acc_trgt.query !== undefined ? __ink_acc_trgt.query : null)})()); return __ink_assgn_trgt})(); (() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(searchElapsedMs, floor(((() => { return (time() - start) })() * 1000))) : (__ink_assgn_trgt.searchElapsedMs) = floor(((() => { return (time() - start) })() * 1000)); return __ink_assgn_trgt})(); (() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(selectedIdx, 0) : (__ink_assgn_trgt.selectedIdx) = 0; return __ink_assgn_trgt})(); __ink_match(trim((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[query] || null : (__ink_acc_trgt.query !== undefined ? __ink_acc_trgt.query : null)})(), __Ink_String(` `)), [[() => (__Ink_String(``)), () => ((() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(showPreview__ink_qm__, false) : (__ink_assgn_trgt.showPreview__ink_qm__) = false; return __ink_assgn_trgt})())]]); return render() })();
root = bind(document, __Ink_String(`querySelector`))(__Ink_String(`#root`));
r = Renderer(root);
update = (() => {let __ink_acc_trgt = __as_ink_string(r); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[update] || null : (__ink_acc_trgt.update !== undefined ? __ink_acc_trgt.update : null)})();
render = () => update(h(__Ink_String(`div`), [__Ink_String(`app`)], [Sidebar(), __ink_match((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[showPreview__ink_qm__] || null : (__ink_acc_trgt.showPreview__ink_qm__ !== undefined ? __ink_acc_trgt.showPreview__ink_qm__ : null)})(), [[() => (true), () => (DocPreview())]])]));
selectDown = evt => (() => { let el; bind(evt, __Ink_String(`preventDefault`))(); (() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(selectedIdx, ((() => { return __as_ink_string((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[selectedIdx] || null : (__ink_acc_trgt.selectedIdx !== undefined ? __ink_acc_trgt.selectedIdx : null)})() + 1) })() % len((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[results] || null : (__ink_acc_trgt.results !== undefined ? __ink_acc_trgt.results : null)})()))) : (__ink_assgn_trgt.selectedIdx) = ((() => { return __as_ink_string((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[selectedIdx] || null : (__ink_acc_trgt.selectedIdx !== undefined ? __ink_acc_trgt.selectedIdx : null)})() + 1) })() % len((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[results] || null : (__ink_acc_trgt.results !== undefined ? __ink_acc_trgt.results : null)})())); return __ink_assgn_trgt})(); render(); return __ink_match(el = querySelector(__Ink_String(`.search-result.selected`)), [[() => (null), () => (null)], [() => (__Ink_Empty), () => (bind(el, __Ink_String(`scrollIntoView`))({block: __Ink_String(`nearest`)}))]]) })();
selectUp = evt => (() => { let el; bind(evt, __Ink_String(`preventDefault`))(); (() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(selectedIdx, ((() => { return (__as_ink_string(len((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[results] || null : (__ink_acc_trgt.results !== undefined ? __ink_acc_trgt.results : null)})()) + (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[selectedIdx] || null : (__ink_acc_trgt.selectedIdx !== undefined ? __ink_acc_trgt.selectedIdx : null)})()) - 1) })() % len((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[results] || null : (__ink_acc_trgt.results !== undefined ? __ink_acc_trgt.results : null)})()))) : (__ink_assgn_trgt.selectedIdx) = ((() => { return (__as_ink_string(len((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[results] || null : (__ink_acc_trgt.results !== undefined ? __ink_acc_trgt.results : null)})()) + (() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[selectedIdx] || null : (__ink_acc_trgt.selectedIdx !== undefined ? __ink_acc_trgt.selectedIdx : null)})()) - 1) })() % len((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[results] || null : (__ink_acc_trgt.results !== undefined ? __ink_acc_trgt.results : null)})())); return __ink_assgn_trgt})(); render(); return __ink_match(el = querySelector(__Ink_String(`.search-result.selected`)), [[() => (null), () => (null)], [() => (__Ink_Empty), () => (bind(el, __Ink_String(`scrollIntoView`))({block: __Ink_String(`nearest`)}))]]) })();
bind((() => {let __ink_acc_trgt = __as_ink_string(document); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[body] || null : (__ink_acc_trgt.body !== undefined ? __ink_acc_trgt.body : null)})(), __Ink_String(`addEventListener`))(__Ink_String(`keydown`), evt => (() => { let searchBox; return __ink_match((() => {let __ink_acc_trgt = __as_ink_string(evt); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[key] || null : (__ink_acc_trgt.key !== undefined ? __ink_acc_trgt.key : null)})(), [[() => (__Ink_String(`Tab`)), () => (__ink_match((() => {let __ink_acc_trgt = __as_ink_string(evt); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[shiftKey] || null : (__ink_acc_trgt.shiftKey !== undefined ? __ink_acc_trgt.shiftKey : null)})(), [[() => (true), () => (selectUp(evt))], [() => (__Ink_Empty), () => (selectDown(evt))]]))], [() => (__Ink_String(`ArrowUp`)), () => (selectUp(evt))], [() => (__Ink_String(`ArrowDown`)), () => (selectDown(evt))], [() => (__Ink_String(`Enter`)), () => (render((() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(showPreview__ink_qm__, true) : (__ink_assgn_trgt.showPreview__ink_qm__) = true; return __ink_assgn_trgt})()))], [() => (__Ink_String(`Escape`)), () => (render((() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(showPreview__ink_qm__, false) : (__ink_assgn_trgt.showPreview__ink_qm__) = false; return __ink_assgn_trgt})()))], [() => (__Ink_String(`/`)), () => (__ink_match(searchBox = querySelector(__Ink_String(`.search-box-input`)), [[() => (null), () => (null)], [() => (__Ink_Empty), () => ((() => { bind(evt, __Ink_String(`preventDefault`))(); return bind(searchBox, __Ink_String(`focus`))() })())]]))], [() => (__Ink_String(`\``)), () => ((() => { bind(evt, __Ink_String(`preventDefault`))(); (() => {let __ink_assgn_trgt = __as_ink_string(State); __is_ink_string(__ink_assgn_trgt) ? __ink_assgn_trgt.assign(theme, (() => { return __ink_match((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[theme] || null : (__ink_acc_trgt.theme !== undefined ? __ink_acc_trgt.theme : null)})(), [[() => (__Ink_String(`dark`)), () => (__Ink_String(`light`))], [() => (__Ink_Empty), () => (__Ink_String(`dark`))]]) })()) : (__ink_assgn_trgt.theme) = (() => { return __ink_match((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[theme] || null : (__ink_acc_trgt.theme !== undefined ? __ink_acc_trgt.theme : null)})(), [[() => (__Ink_String(`dark`)), () => (__Ink_String(`light`))], [() => (__Ink_Empty), () => (__Ink_String(`dark`))]]) })(); return __ink_assgn_trgt})(); bind((() => {let __ink_acc_trgt = __as_ink_string((() => {let __ink_acc_trgt = __as_ink_string(document); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[body] || null : (__ink_acc_trgt.body !== undefined ? __ink_acc_trgt.body : null)})()); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[classList] || null : (__ink_acc_trgt.classList !== undefined ? __ink_acc_trgt.classList : null)})(), __Ink_String(`toggle`))(__Ink_String(`dark`), __ink_eq((() => {let __ink_acc_trgt = __as_ink_string(State); return __is_ink_string(__ink_acc_trgt) ? __ink_acc_trgt.valueOf()[theme] || null : (__ink_acc_trgt.theme !== undefined ? __ink_acc_trgt.theme : null)})(), __Ink_String(`dark`))); return render() })())]]) })());
each(Modules, fetchModuleDocs);
render()


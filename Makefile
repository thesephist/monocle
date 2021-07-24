all: run

# run app server
run:
	ink src/main.ink

# build dependencies
build-libs:
	september translate \
		lib/stub.ink \
		vendor/std.ink \
		vendor/str.ink \
		vendor/quicksort.ink \
		lib/fastsort.js.ink \
		> static/ink/lib.js

build-monocle:
	september translate \
		lib/tokenizer.ink \
		lib/indexer.ink \
		lib/ranker.ink \
		lib/stemmer.ink \
		lib/searcher.ink \
		> static/ink/monocle.js

# build app clients
build:
	cat static/js/ink.js \
		static/js/torus.min.js \
		> static/ink/vendor.js
	september translate \
		lib/torus.js.ink \
		src/app.js.ink \
		| tee /dev/stderr > static/ink/common.js
	cat \
		static/ink/vendor.js \
		static/ink/lib.js \
		static/ink/monocle.js \
		static/ink/common.js \
		> static/ink/bundle.js
b: build

# run all builds from scratch
build-all: build-libs build-monocle build

# re-build document indexes
index:
	ink src/index.ink
	# remove control characters that sneak into content. These are filtered out
	# in the index but not in doc sources, and trips up JSON parsers.
	LC_ALL=C tr -d '[:cntrl:]' < static/indexes/docs.json > /tmp/docs.json
	mv /tmp/docs.json static/indexes/docs.json
	# gzip
	gzip --best < static/indexes/docs.json > static/indexes/docs.json.gz
	gzip --best < static/indexes/index.json > static/indexes/index.json.gz
	# brotli
	brotli -kZf static/indexes/docs.json
	brotli -kZf static/indexes/index.json

# build whenever Ink sources change
watch:
	ls lib/*.ink src/*.ink modules/*.ink | entr make build
w: watch

# run all tests under test/
check:
	ink ./test/main.ink
t: check

fmt:
	inkfmt fix lib/*.ink src/*.ink modules/*.ink test/*.ink
f: fmt


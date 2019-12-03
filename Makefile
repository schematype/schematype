SHELL := bash
ROOT := $(shell cd .. && pwd)

GRAMMAR := $(ROOT)/grammar
NODE_MODULES := $(ROOT)/node_modules
PERL5 := $(ROOT)/perl5
TESTML := $(ROOT)/testml

GRAMMAR_COFFEE := lib/schematype-compiler/grammar.coffee
COFFEE_FILES := $(shell find lib -type f)
JS_FILES := $(COFFEE_FILES:%.coffee=build/%.js)

export PATH := $(PWD)/bin:$(NODE_MODULES)/.bin:$(PERL5)/bin:$(PATH)
export TESTML_RUN := perl5

test := test/*.tml
j := 1

default:

.PHONY: test
test: build
	(source $(TESTML)/.rc && prove -v -j$(j) $(test))

.PHONY: build
build: $(JS_FILES) build/bin/schematype-compiler

build/bin/schematype-compiler: bin/schematype-compiler
	@mkdir -p build/bin
	echo '#!/usr/bin/env node' > $@
	coffee -cp $< >> $@
	chmod +x $@

build/lib/schematype-compiler/%.js: lib/schematype-compiler/%.coffee
	@mkdir -p build/lib/schematype-compiler
	coffee -cp $< > $@

lib/schematype-compiler/grammar.coffee: $(GRAMMAR)/schematype.pgx.json
	make -C $(ROOT) node_modules perl5
	( \
	    grep -B99 make_tree $@; \
	    sed 's/^/    /' < $< \
	) > tmp-grammar
	mv tmp-grammar $@

$(GRAMMAR)/schematype.pgx.json: $(GRAMMAR)
	make -C $< build

$(GRAMMAR) $(NODE_MODULES) $(PERL5) $(TESTML):
	make -C $(ROOT) $(@:$(ROOT)/%=%)

clean:
	rm -fr build test/.testml

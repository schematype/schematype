SHELL := bash
ROOT := $(shell cd .. && pwd)

BUILD := $(ROOT)/compiler/build
GRAMMAR := $(ROOT)/grammar
NODE_MODULES := $(ROOT)/node_modules
PERL5 := $(ROOT)/perl5
PERL5LIB := $(PERL5)/lib/perl5
TEST_COMPILER := $(ROOT)/test.compiler
TESTML := $(ROOT)/testml

GRAMMAR_COFFEE := lib/schematype-compiler/grammar.coffee
COFFEE_FILES := $(shell find lib -type f)
JS_FILES := $(COFFEE_FILES:%.coffee=build/%.js)

export PATH := $(BUILD)/bin:$(NODE_MODULES)/.bin:$(PERL5)/bin:$(PATH)
export TESTML_RUN := perl5
export PERL5LIB := $(PERL5LIB)

test := test/*.tml
j := 1

#------------------------------------------------------------------------------
default:

.PHONY: test
test: build $(TESTML) $(TEST_COMPILER)
	(source $(TESTML)/.rc && prove -v -j$(j) $(test))

.PHONY: build
build: dep-perl dep-node $(NODE_MODULES) $(JS_FILES) build/bin/schematype-compiler

clean:
	rm -fr build/ test/.testml/ $(TEST_COMPILER)/.testml/

#------------------------------------------------------------------------------
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

$(GRAMMAR) $(NODE_MODULES) $(PERL5) $(TEST_COMPILER) $(TESTML):
	make -C $(ROOT) $(@:$(ROOT)/%=%)

#------------------------------------------------------------------------------
dep-node:
	@command -v node || { \
	    echo "ERROR: Action requires 'node' (NodeJS) to be installed."; \
	    exit 1; \
	}
dep-perl:
	@command -v perl || { \
	    echo "ERROR: Action requires 'perl' (Perl 5) to be installed."; \
	    exit 1; \
	}

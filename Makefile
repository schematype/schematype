SHELL := bash
ROOT := $(shell cd .. && pwd)

LINKER := $(ROOT)/linker
BUILD := $(LINKER)/build
NODE_MODULES := $(ROOT)/node_modules
TEST_LINKER := $(ROOT)/test.linker
TESTML := $(ROOT)/testml

COFFEE_FILES := $(shell find bin -type f && find lib -name '*.coffee')
JS_FILES := $(COFFEE_FILES:%.coffee=%.js)
JS_FILES := $(JS_FILES:%=build/%)
TESTML_RUNNER := $(TESTML)/src/node/lib/testml/run/tap.js

export PATH := $(BUILD)/bin:$(NODE_MODULES)/.bin:$(PATH)
export TESTML_RUN := node-tap
export NODE_PATH := $(LINKER)/build/lib:$(NODE_MODULES)

test := test/*.tml
j := 1
export SCHEMATYPE_LINKER_DEBUG := $(debug)

#------------------------------------------------------------------------------
default:

.PHONY: test
test: build $(TESTML_RUNNER) $(TEST_LINKER) test/testml-bridge.js
	(source $(TESTML)/.rc && prove -v -j$(j) $(test))

.PHONY: build
build: dep-node $(NODE_MODULES) $(JS_FILES)

clean:
	rm -fr build/ test/testml-bridge.js test/.testml/ $(TEST_LINKER)/.testml/

#------------------------------------------------------------------------------
build/bin/%: bin/%
	mkdir -p $$(dirname $@)
	echo '#!/usr/bin/env node' > "$@"
	coffee -cp $< >> $@
	chmod +x "$@"

build/%.js: %.coffee
	mkdir -p $$(dirname $@)
	coffee -cp $< > $@

$(NODE_MODULES) $(TEST_LINKER) $(TESTML):
	make -C $(ROOT) $(@:$(ROOT)/%=%)

test/testml-bridge.js: test/testml-bridge.coffee
	coffee -cp $< > $@

$(TESTML_RUNNER): $(TESTML)
	make -C $(TESTML)/src/node build
	touch $(TESTML_RUNNER)

#------------------------------------------------------------------------------
dep-node:
	@command -v node >/dev/null || { \
	    echo "ERROR: Action requires 'node' (NodeJS) to be installed."; \
	    exit 1; \
	}

SHELL := bash
ROOT := $(shell cd .. && pwd)
STP := $(ROOT)/stp

TESTML := $(ROOT)/.testml

export PATH := $(STP)/bin:$(PATH)
export TESTML_RUN := bash-tap

test := test/*.tml
j := 1
export TESTML_COMPILER_DEBUG := $(debug)


#------------------------------------------------------------------------------
default:

.PHONY: test
test: $(TESTML)
	(source $(TESTML)/.rc && prove -v -j$(j) $(test))

$(TESTML):
	make -C $(ROOT) $(@:$(ROOT)/%=%)

clean:
	rm -fr test/.testml/ test/cache/

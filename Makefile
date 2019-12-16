SHELL := bash
ROOT := $(shell cd .. && pwd)

join_path = $(subst $(eval) ,:,$1)

STP := $(ROOT)/stp
PERL5 := $(ROOT)/perl5
TESTML := $(ROOT)/.testml

export PATH := $(STP)/bin:$(ROOT)/bin:$(TESTML)/bin:$(PATH)
export PERL5LIB := $(PERL5)/lib/perl5
export TESTML_RUN := bash-tap

test := test/*.tml
j := 1
export TESTML_COMPILER_DEBUG := $(debug)


#------------------------------------------------------------------------------
default:

.PHONY: test
test: $(TESTML) $(PERL5) $(BUILD_BINS)
	make -C $(ROOT) build-bin
	prove -v -j$(j) $(test)

$(TESTML) $(PERL5):
	make -C $(ROOT) $(@:$(ROOT)/%=%)

clean:
	rm -fr test/.testml/ test/cache/

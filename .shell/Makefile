SHELL := bash
ROOT := $(shell cd .. && pwd)

DEPS := \
  $(ROOT)/doc \
  $(ROOT)/stp \

ALL_SHELL_FILES := \
  $(ROOT)/.rc \
  $(ROOT)/stp/bin/stp \
  $(ROOT)/stp/lib/stdlib.bash \
  $(ROOT)/stp/lib/getopt.bash \
  $(ROOT)/doc/bin/make-man-page

default:

shellcheck: $(DEPS)
	shellcheck $(ALL_SHELL_FILES)

$(DEPS):
	make -C $(ROOT) $(@:$(ROOT)/%=%)

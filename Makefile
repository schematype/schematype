SHELL := bash
ROOT := $(shell cd .. && pwd)

ALL_DOC := stp.md
ALL_MAN := $(ALL_DOC:%.md=man/man1/%.1)

default:

.PHONY: man
man: $(ALL_MAN)

man/man1/%.1: %.md
	./bin/make-man-page $< > $@

SHELL := bash

WORK_BRANCHES := \
    compiler \
    grammar \
    node_modules \
    test/compiler \
    perl5 \

WORK_REPOS := \
    testml \

WORK_DIRS := \
    $(WORK_BRANCHES) \
    $(WORK_REPOS) \

default:

work: $(WORK_DIRS)

$(WORK_BRANCHES):
	git branch --track $@ origin/$@ 2>/dev/null || true
	git worktree add -f $@ $@

testml:
	git clone git@github.com:testml-lang/testml $@

clean:
	rm -f package-lock.json

realclean: clean
	rm -fr $(WORK_DIRS) test


.PHONY: test
test: test-compiler

test-compiler: compiler
	make -C $< test

status:
	@for d in $(WORK_DIRS); do \
	    [ -d $$d ] || continue; \
	    ( \
	      echo "=== $$d"; \
	      cd $$d; \
	      output=$$( \
		git status | grep -Ev '(^On branch|up.to.date|nothing to commit)'; \
		git log --graph --decorate --pretty=oneline --abbrev-commit -10 | grep wip; \
	      ); \
	      [ -z "$$output" ] || echo "$$output"; \
	    ); \
	done
	@echo "=== $$(git rev-parse --abbrev-ref HEAD)"
	@git status | grep -Ev '(^On branch|up.to.date|nothing to commit)' || true
	@git log --graph --decorate --pretty=oneline --abbrev-commit -10 | grep wip || true


SHELL := bash

WORK_BRANCHES := \
    compiler \
    docker \
    grammar \
    node_modules \
    note \
    test.compiler \
    perl5 \

WORK_REPOS := \
    testml \

WORK_DIRS := \
    $(WORK_BRANCHES) \
    $(WORK_REPOS) \

#------------------------------------------------------------------------------
.PHONY: test
test: test-compiler

test-compiler: compiler
	make -C $< test

#------------------------------------------------------------------------------
docker-build docker-shell docker-test: docker
	make -C $< $(@:docker-%=%)

#------------------------------------------------------------------------------
default:

work: $(WORK_DIRS)

$(WORK_BRANCHES):
	git branch --track $@ origin/$@ 2>/dev/null || true
	git worktree add -f $@ $@

testml:
	git clone https://github.com/testml-lang/testml $@

clean:
	rm -f package-lock.json
	@for d in $(WORK_BRANCHES); do \
	    if [[ -f $$d/Makefile ]]; then \
		make -C $$d clean; \
	    fi; \
	done

realclean: clean
	rm -fr $(WORK_DIRS) test

#------------------------------------------------------------------------------
pull: work
	@for d in $(WORK_BRANCHES); do \
	    [[ -d $$d ]] || continue; \
	    ( \
	      echo "=== $$d"; \
	      cd $$d; \
	      git pull --rebase; \
	    ); \
	done
	@echo "=== $$(git rev-parse --abbrev-ref HEAD)"
	@git pull --rebase

status:
	@for d in $(WORK_BRANCHES); do \
	    [[ -d $$d ]] || continue; \
	    ( \
	      echo "=== $$d"; \
	      cd $$d; \
	      output=$$( \
		git status | grep -Ev '(^On branch|up.to.date|nothing to commit)'; \
		git log --graph --decorate --pretty=oneline --abbrev-commit -10 | grep wip; \
		git clean -dxn; \
	      ); \
	      [[ -z $$output ]] || echo "$$output"; \
	    ); \
	done
	@echo "=== $$(git rev-parse --abbrev-ref HEAD)"
	@git status | grep -Ev '(^On branch|up.to.date|nothing to commit)' || true
	@git log --graph --decorate --pretty=oneline --abbrev-commit -10 | grep wip || true

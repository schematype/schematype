SHELL := bash

WORK_BRANCHES := \
    compiler \
    doc \
    docker \
    example \
    generator-jsonschema \
    linker \
    node_modules \
    note \
    perl5 \
    stp \
    testml \
    validator \

WORK_REPOS := \
    .testml \

WORK_DIRS := \
    $(WORK_BRANCHES) \
    $(WORK_REPOS) \

BUILD_BRANCHES := \
    compiler \
    linker \
    stp \

BUILD_BIN := \
    bin/schematype-compiler \
    bin/schematype-linker \
    bin/schematype-validator \
    # bin/schematype-generator-jsonschema \

ALL_BIN := \
    bin/stp \
    $(BUILD_BIN)

action-dir = $(1:bin/schematype-%=%)

.SECONDEXPANSION:
#------------------------------------------------------------------------------
default: status

#------------------------------------------------------------------------------
.PHONY: test
test: test-stp test-compiler test-linker test-generator-jsonschema

test-all: test-shellcheck test

test-%: %
	make -C $< test

test-shellcheck:
	make -C .shell shellcheck

#------------------------------------------------------------------------------
build: $(ALL_BIN) man/man1

build-bin: $(BUILD_BIN)

bin/stp: stp bin lib stp/bin/stp
	cp -r $</bin/* bin/
	cp -r $</lib/* lib/

bin/schematype-%: % bin lib $$(shell find $$(call action-dir,$$@) -type f | grep -v '\.swp')
	make -C $< build
	cp -r $</build/bin/* bin/
	cp -r $</build/lib/* lib/

bin lib:
	mkdir -p $@

man/man1: doc/man/man1
	mkdir -p $@
	cp -r $</* $@/

doc/man/man1: doc
	make -C doc man

#------------------------------------------------------------------------------
docker-build docker-shell docker-test: docker
	make -C $< $(@:docker-%=%)

#------------------------------------------------------------------------------
work: $(WORK_DIRS)

$(WORK_BRANCHES):
	git branch --track $@ origin/$@ 2>/dev/null || true
	git worktree add -f $@ $@

.testml:
	git clone https://github.com/testml-lang/testml $@

clean:
	rm -f package-lock.json
	rm -fr bin lib man cache
	@for d in $(WORK_BRANCHES); do \
	    if [[ -f $$d/Makefile ]]; then \
		make -C $$d clean; \
	    fi; \
	done

realclean: clean
	rm -fr $(WORK_DIRS)

#------------------------------------------------------------------------------
s: status

status:
	@for d in $(WORK_BRANCHES); do \
	  [[ -d $$d ]] || continue; \
	  ( \
	    echo "=== $$d"; \
	    cd $$d; \
	    output=$$( \
	      git status --short | grep -Ev '(^On branch|up.to.date|nothing to commit)'; \
	      git log --oneline origin/$$d..HEAD; \
	      git log --graph --decorate --pretty=oneline --abbrev-commit -10 | grep wip; \
	      git clean -dxn; \
	    ); \
	    [[ -z $$output ]] || echo "$$output"; \
	  ); \
	done
	@( \
	  d="$$(git rev-parse --abbrev-ref HEAD)"; \
	  echo "=== $$d"; \
	  output=$$( \
	    d=$$(git rev-parse --abbrev-ref HEAD); \
	    git status --short | grep -Ev '(^On branch|up.to.date|nothing to commit)' || true; \
	    git log --oneline origin/$$d..HEAD || true; \
	    git log --graph --decorate --pretty=oneline --abbrev-commit -10 | grep wip || true; \
	    git clean -dxn | grep -v '^Would skip '; \
	  ); \
	  [[ -z $$output ]] || echo "$$output"; \
	)

pull:
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

push:
	@for d in $(WORK_BRANCHES); do \
	    [[ -d $$d ]] || continue; \
	    ( \
	      echo "=== $$d"; \
	      cd $$d; \
	      git push; \
	    ); \
	done
	@echo "=== $$(git rev-parse --abbrev-ref HEAD)"
	@git push

diff:
	@for d in $(WORK_BRANCHES); do \
	    [[ -d $$d ]] || continue; \
	    ( \
	      echo "=== $$d"; \
	      cd $$d; \
	      git diff; \
	    ); \
	done
	@echo "=== $$(git rev-parse --abbrev-ref HEAD)"
	@git diff

commit:
	@for d in $(WORK_BRANCHES); do \
	    [[ -d $$d ]] || continue; \
	    ( \
	      echo "=== $$d"; \
	      cd $$d; \
	      git add . && git commit -m '$(msg)' || true; \
	    ); \
	done
	@echo "=== $$(git rev-parse --abbrev-ref HEAD)"
	@git add . && git commit -m '$(msg)' || true

SHELL := bash
ROOT := $(shell cd .. && pwd)
HERE := $(ROOT)/test-libfyaml

TESTML := $(ROOT)/.testml

TOOLS := bin/fy-tool

test = *.tml

export PATH := $(HERE)/bin:$(PATH)

.DELETE_ON_ERROR:
test: libfyaml $(TESTML) $(TOOLS)
	(source $(TESTML)/.rc && prove -v $(test))

libfyaml:
	git clone git@github.com:pantoniou/libfyaml
	( \
	    cd $@ && \
	    ./bootstrap.sh && \
	    ./configure --prefix=$(HERE) && \
	    make; \
	)

bin/fy-tool: libfyaml
	( \
	    cd $< && \
	    make install; \
	)

realclean: clean
	rm -fr libfyaml

clean:
	rm -fr .testml bin lib include

$(TESTML):
	make -C $(ROOT) $(@:$(ROOT)/%=%)

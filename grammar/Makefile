ROOT := $(shell cd ../.. && pwd)
GRAMMAR := schematype.pgx

export PATH := $(ROOT)/perl5/bin:$(PATH)

DEPS := \
    $(ROOT)/perl5 \

.DELETE_ON_ERROR:
#------------------------------------------------------------------------------
default:

# XXX Switch to JS Pegex compiler.
build: $(GRAMMAR) dep-perl $(DEPS)
	pegex-compile-to-json < $< > $<.json

$(DEPS):
	make -C $(ROOT) $(@:$(ROOT)/%=%)

clean:
	rm -fr $(GRAMMAR).json

#------------------------------------------------------------------------------
dep-perl:
	@command -v perl || { \
	    echo "ERROR: Action requires 'perl' (Perl 5) to be installed."; \
	    exit 1; \
	}

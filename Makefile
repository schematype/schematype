SHELL := bash

#------------------------------------------------------------------------------
default:

update:
	cpanm -L . \
	    Pegex
	perl -pi -e 's/JSON::XS/JSON::PP/' lib/perl5/Pegex/Compiler.pm
	( \
	    shopt -s globstar; \
	    rm -fr man lib/perl5/x86_64-linux/ lib/perl5/auto/ \
		lib/perl5/File/ lib/**/*.pod lib/perl5/Pegex/Tutorial/ \
	)


clean:

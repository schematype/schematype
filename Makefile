default:

update:
	cpanm -L . \
	    Capture::Tiny \
	    Pegex
	perl -pi -e 's/JSON::XS/JSON::PP/' lib/perl5/Pegex/Compiler.pm
	rm -fr man lib/perl5/x86_64-linux/ lib/perl5/auto/

default:

update:
	cpanm -L . Pegex
	rm -fr man lib/perl5/x86_64-linux/ lib/perl5/auto/

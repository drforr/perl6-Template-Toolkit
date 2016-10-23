use Test;
use Template::Toolkit;

my $tt = Template::Toolkit.new;

# XXX Tells Template::Toolkit to just return, rather than
# XXX print to STDOUT. This overrides any OUTPUT value
# XXX that's been set, and is for internal testing only.
my $*TESTING = 1;

# All of these tests are checked against Template Toolkit v5.
#
subtest {
	is	$tt.process( \Q{hello} ),
		Q{hello},
		Q{text};

	is	$tt.process( \Q{hello 'brave' world} ),
		Q{hello 'brave' world},
		Q{text with quotes};

	is	$tt.process( \Q{hello \'brave\' world} ),
		Q{hello \'brave\' world},
		Q{text with single quotes};

	is	$tt.process( \Q{hello \"brave\" world} ),
		Q{hello \"brave\" world},
		Q{text with double quotes};

	# Open-tag with no close tag is interpreted as regular text.
	#
	is	$tt.process( \Q{does[% this string break?} ),
		Q{does[% this string break?},
		Q{open-tag};

	# Close-tag with no open tag is interpreted as regular text.
	#
	is	$tt.process( \Q{does%] this string break?} ),
		Q{does%] this string break?},
		Q{close-tag};

	# Close-tag followed by open-tag is also interpreted as regular text.
	# (Note the opposite order)
	#
	is	$tt.process( \Q{does%] [%this string break?} ),
		Q{does%] [%this string break?},
		Q{close-tag before open-tag};

	# Overlapping open and close tag
	#
	is	$tt.process( \Q{does [%] this string break?} ),
		\Q{does [%] this string break?},
		Q{overlapping open and close tags};

	done-testing;
}, Q{text};

done-testing;

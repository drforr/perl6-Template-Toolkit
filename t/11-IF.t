use Test;
use Template::Toolkit;

my $tt = Template::Toolkit.new;

# XXX Tells Template::Toolkit to just return, rather than
# XXX print to STDOUT. This overrides any OUTPUT value
# XXX that's been set, and is for internal testing only.
my $*TESTING = 1;

# XXX GET ran, no need to check compound terms or single strings.
#
subtest {
#`(
	is	$tt.process( \Q{[%IF 0; 27; END%]} ),
		Q{},
		Q{false};

	is	$tt.process( \Q{[%IF 1; 27; END%]} ),
		Q{27},
		Q{true};
)
	done-testing;
}, Q{constant single directive};

subtest {
	is	$tt.process( \Q{[%IF 0%]27[%END%]} ),
		Q{},
		Q{false};

	is	$tt.process( \Q{[%IF 1%]27[%END%]} ),
		Q{27},
		Q{true};

	done-testing;
}, Q{constant, multiple directives};

subtest {
#`(
	is	$tt.process(
			\Q{[%IF brave; 27; END%]},
			{ brave => 0 }
		),
		Q{},
		Q{false};

	is	$tt.process(
			\Q{[%IF brave; 27; END%]},
			{ brave => 1 }
		),
		Q{27},
		Q{true};
)
	done-testing;
}, Q{variable, single directive};

subtest {
	is	$tt.process(
			\Q{[%IF brave%]27[%END%]},
			{ brave => 0 }
		),
		Q{},
		Q{false};

	is	$tt.process(
			\Q{[%IF brave%]27[%END%]},
			{ brave => 1 }
		),
		Q{27},
		Q{true};

	done-testing;
}, Q{variable, multiple directives};

done-testing;

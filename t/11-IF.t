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
	subtest {
#`(
		is	$tt.process( \Q{[%IF 0; 27; END%]} ),
			Q{},
			Q{false integer};

		is	$tt.process( \Q{[%IF ''; 27; END%]} ),
			Q{},
			Q{false string};

		is	$tt.process( \Q{[%IF 1; 27; END%]} ),
			Q{27},
			Q{true integer};

		is	$tt.process( \Q{[%IF 'a'; 27; END%]} ),
			Q{27},
			Q{true string};

		subtest {
			is	$tt.process(
					\Q{[%IF 0; 27; ELSE; 42; END%]}
				),
				Q{42},
				Q{false integer};

			is	$tt.process(
					\Q{[%IF ''; 27; ELSE; 42; END%]}
				),
				Q{42},
				Q{false string};

			is	$tt.process(
					\Q{[%IF 1; 27; ELSE; 42; END%]}
				),
				Q{27},
				Q{true integer};

			is	$tt.process(
					\Q{[%IF 'a'; 27; ELSE; 42; END%]}
				),
				Q{27},
				Q{true string};

			done-testing;
		}, Q{ELSE};

		subtest {
			done-testing;
		}, Q{ELSIF};
)
		done-testing;
	}, Q{constant single directive};

	subtest {
		is	$tt.process( \Q{[%IF 0%]27[%END%]} ),
			Q{},
			Q{false integer};

		is	$tt.process( \Q{[%IF ''%]27[%END%]} ),
			Q{},
			Q{false string};

		is	$tt.process( \Q{[%IF 1%]27[%END%]} ),
			Q{27},
			Q{true integer};

		is	$tt.process( \Q{[%IF 'a'%]27[%END%]} ),
			Q{27},
			Q{true string};

		subtest {
			is	$tt.process( \Q{[%IF 0%]27[%ELSE%]42[%END%]} ),
				Q{42},
				Q{false integer};

			is	$tt.process( \Q{[%IF ''%]27[%ELSE%]42[%END%]} ),
				Q{42},
				Q{false string};

			is	$tt.process( \Q{[%IF 1%]27[%ELSE%]42[%END%]} ),
				Q{27},
				Q{true integer};

			is	$tt.process(
					\Q{[%IF 'a'%]27[%ELSE%]42[%END%]}
				),
				Q{27},
				Q{true string};

			done-testing;
		}, Q{ELSE};

		# Not going to test all int/string combinations.
		# Too much combinatorial explosion.
		#
		subtest {
			is	$tt.process(
					\Q{[%IF 0%]27[%ELSIF 0%]9[%ELSE%]42[%END%]}
				),
				Q{42},
				Q{false integer, false integer};

			is	$tt.process(
					\Q{[%IF 1%]27[%ELSIF 0%]9[%ELSE%]42[%END%]}
				),
				Q{27},
				Q{true integer, false integer};

			is	$tt.process(
					\Q{[%IF 0%]27[%ELSIF 1%]9[%ELSE%]42[%END%]}
				),
				Q{9},
				Q{false integer, true integer};

			is	$tt.process(
					\Q{[%IF 1%]27[%ELSIF 1%]9[%ELSE%]42[%END%]}
				),
				Q{27},
				Q{true integer, true integer};

			done-testing;
		}, Q{ELSIF};

		done-testing;
	}, Q{constant, multiple directives};

	done-testing;
}, Q{constant condition};

done-testing;

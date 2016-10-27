use Test;
use Template::Toolkit;

my $tt = Template::Toolkit.new;

# XXX Tells Template::Toolkit to just return, rather than
# XXX print to STDOUT. This overrides any OUTPUT value
# XXX that's been set, and is for internal testing only.
my $*TESTING = 1;

subtest {
#`(
)
	done-testing;
}, Q{single directive};

subtest {
	is	$tt.process( \Q{[%FOREACH item = items%]27[%END%]} ),
		Q{},
		Q{no control variable};

	# N.B. if it's not referenced, there's no need to test variants.
	#
	is	$tt.process(
			\Q{[%FOREACH item = items%]27[%END%]},
			{ brave => Any }
		),
		Q{},
		Q{unrelated variable};

	subtest {
		is	$tt.process(
				\Q{[%FOREACH item = itemss%]27[%END%]},
				{ items => Any }
			),
			Q{},
			Q{Any};

		is	$tt.process(
				\Q{[%FOREACH item = items%]27[%END%]},
				{ items => 1 }
			),
			Q{27},
			Q{integer};

		is	$tt.process(
				\Q{[%FOREACH item = items%]27[%END%]},
				{ items => [ ] }
			),
			Q{},
			Q{empty arrayref};

		is	$tt.process(
				\Q{[%FOREACH item = items%]27[%END%]},
				{ items => [ 1 ] }
			),
			Q{27},
			Q{populated arrayref};

		is	$tt.process(
				\Q{[%FOREACH item = items%]27[%END%]},
				{ items => [ 1, 2 ] }
			),
			Q{2727},
			Q{populated arrayref};
#`(
		is	$tt.process(
				\Q{[%FOREACH items%]27[%END%]},
				{ items => [ 1 ] }
			),
			Q{27},
			Q{populated arrayref};
)
		done-testing;
	}, Q{related variable};

	done-testing;
}, Q{constant};

done-testing;

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
	is	$tt.process( \Q{[%27%]} ),
		Q{27},
		Q{integer};
	
	is	$tt.process( \Q{[% -27%]} ),
		Q{-27},
		Q{negative integer (Not testing [%--%] though.)};
	
	is	$tt.process( \Q{[%'hello'%]} ),
		Q{hello},
		Q{single-quote};
	
	is	$tt.process( \Q{[%"hello"%]} ),
		Q{hello},
		Q{double-quote};

	is	$tt.process( \Q{[%'hello "brave" world'%]} ),
		Q{hello "brave" world},
		Q{single-quote, nested double-quote};

	is	$tt.process( \Q{[%'hello \'brave\' world'%]} ),
		Q{hello \'brave\' world},
		Q{single-quote, nested escaped single-quote};
	
	is	$tt.process( \Q{[%"hello 'brave' world"%]} ),
		Q{hello 'brave' world},
		Q{double-quote, nested single-quote};

	is	$tt.process( \Q{[%"hello \"brave\" world"%]} ),
		Q{hello \"brave\" world},
		Q{double-quote, nested escaped double-quote};

	done-testing;
}, Q{constant};

subtest {
	is	$tt.process( \Q{%[%6%]%} ),
		Q{%6%},
		Q{edge case};
	
	is	$tt.process( \Q{hello [%"brave"%] world} ),
		Q{hello brave world},
		Q{text-constant-text};

	done-testing;
}, Q{mixed text+constant};

subtest {
	is	$tt.process( \Q{[%brave%]} ),
		Q{},
		Q{no stash};
	
	is	$tt.process( \Q{[%brave%]},
			{ hello => 'brave' }
		),
		Q{},
		Q{unrelated stash};
	
	is	$tt.process( \Q{[%brave%]},
			{ brave => 'hello world' } ),
		Q{hello world},
		Q{related stash};

	done-testing;
}, Q{single stash value};

subtest {
	is	$tt.process( \Q{[%brave()%]} ),
		Q{},
		Q{no stash};

	is	$tt.process(
			\Q{[%brave()%]},
			{ hello => sub () { } }
		),
		Q{},
		Q{unrelated stash};

	subtest {
		# Yes, in TT 5
		# \q{[% brave() %]}, { brave => 42 }
		# substitutes 42, rather than failing
		#
		is	$tt.process( \Q{[%brave()%]},
				{ brave => 'hello world' } ),
			Q{hello world},
			Q{related stash, no arguments};

		# Even if calling with an argument,
		# fallback is used.
		#
		is	$tt.process( \Q{[%brave(42)%]},
				{ brave => 'hello world' } ),
			Q{hello world},
			Q{related stash, one argument};

		done-testing;
	}, Q{stash with constant};

	subtest {
		my $called = False;
#`(
		is	$tt.process(
				\Q{[%brave()%]}, {
					brave => sub {
						$called = True;
						'hello world'
					}
				}
			),
			Q{hello world},
			Q{related stash, no arguments};
		ok $called, Q{stash function gets called};
)

		# Open a new scope so we don't have to reset or localize
		# $called.
		{
			my $called = False;
			is	$tt.process(
					\Q{[%brave(42)%]}, {
						brave => sub (*@args) {
							$called = True;
							'hello world'
						}
					}
				),
				Q{hello world},
				Q{related stash, one unused argument};
			ok $called, Q{stash function gets called};
		}

		{
			my $called = False;
			my $used = False;
			is	$tt.process(
					\Q{[%brave(42)%]}, {
						brave => sub ($x) {
							$called = True;
							$used = True if
								$x == 42;
							'hello world'
						}
					}
				),
				Q{hello world},
				Q{related stash, one unused argument};
			ok $called, Q{stash function gets called};
			ok $used, Q{function gets variable};
		}

		done-testing;
	}, Q{stash with constant};

	done-testing;
}, Q{single stash function};

subtest {
	is	$tt.process( \Q{[%brave.new%]} ),
		Q{},
		Q{no stash};
	
	is	$tt.process( \Q{[%brave.new%]},
			{ hello => 'brave' }
		),
		Q{},
		Q{unrelated stash};
	
	is	$tt.process( \Q{[%brave.new%]},
			{ brave => { new => 'hello world' } } ),
		Q{hello world},
		Q{related stash};

	done-testing;
}, Q{multiple-element stash key};

done-testing;

use v6;

use Test;
use Template::Toolkit;

plan 8;

# One subtest for each configuration option (that we're going to do)
#
subtest {;
}, Q{ENCODING};

subtest {
	plan 1;

	my $tt = Template::Toolkit.new( START_TAG => '(+' );
	is $tt._process( '(+1%]' ), '1';
	plan 2;

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new;
		is $tt._process( Q{(+1%]} ), Q{(+1%]};
	}, Q{disabled};

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new( START_TAG => '(+' );
		is $tt._process( Q{(+1%]} ), '1';
	}, Q{enabled};
}, Q{START_TAG};

subtest {
	plan 2;

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new;
		is $tt._process( Q{[%1+)} ), Q{[%1+)};
	}, Q{disabled};

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new( END_TAG => '+)' );
		is $tt._process( Q{[%1+)} ), '1';
	}, Q{enabled};
}, Q{END_TAG};

subtest {
	plan 2;

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new;
		is $tt._process( Q{%%1} ), Q{%%1};
	}, Q{disabled};

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new( OUTLINE_TAG => '%%' );
		is $tt._process( Q{%%1} ), '1';
	}, Q{enabled};
}, Q{OUTLINE_TAG};

subtest {
	plan 2;

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new;
		is $tt._process( Q{[*1*]} ), Q{[*1*]};
	}, Q{disabled};

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new( TAG_STYLE => 'star' );
		is $tt._process( Q{[*1*]} ), '1';
	}, Q{enabled};
}, Q{TAG_STYLE};

subtest {
	plan 2;

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new;
		is $tt._process( Q{ [%1%]} ), Q{ 1};
	}, Q{disabled};

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new( PRE_CHOMP => 1 );
		is $tt._process( Q{ [%1%]} ), Q{1};
	}, Q{enabled};
}, Q{PRE_CHOMP};

subtest {
	plan 2;

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new;
		is $tt._process( Q{[%1%] } ), Q{1 };
	}, Q{disabled};

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new( POST_CHOMP => 1 );
		is $tt._process( Q{[%1%] } ), Q{1};
	}, Q{enabled};
}, Q{POST_CHOMP};

subtest {
	plan 2;

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new;
		is $tt._process( Q{ [%1%] } ), Q{ 1 };
	}, Q{disabled};

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new( TRIM => 1 );
		is $tt._process( Q{ [%1%] } ), Q{1};
	}, Q{enabled};
}, Q{TRIM};

subtest {
	plan 2;

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new;
		is $tt._process( Q{$a} ), Q{$a};
	}, Q{disabled};

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new( INTERPOLATE => 1 );
		is $tt._process( Q{$a}, { a => 1 } ), Q{1};
	}, Q{enabled};
}, Q{INTERPOLATE};

subtest {
	plan 2;

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new;
		ok $tt._process( Q{[% include = 10 %]} ), Q{};
	}, Q{disabled};

	subtest {
		plan 1;

		my $tt = Template::Toolkit.new( ANYCASE => 1 );
		dies-ok {
			 $tt._process( Q{[% include = 10 %]} )
		};
	}, Q{enabled};
}, Q{ANYCASE};

# XXX	has $.INCLUDE_PATH;
# XXX	has $.DELIMITER;
# XXX	has $.ABSOLUTE;
# XXX	has $.RELATIVE;
# XXX	has $.DEFAULT;
# XXX	has $.BLOCKS;
# XXX	has $.VIEWS;
# XXX	has $.AUTO_RESET = 1;
# XXX	has $.RECURSION;
# XXX	has $.VARIABLES;
# XXX	has $.PREDEFINE;

subtest {
	plan 1;

	# 'constants.pi' is legal but does nothing ordinarily.
	# So we can't drop a constant in and expect it to fail.
	#
	my $tt = Template::Toolkit.new( CONSTANTS => { pi => 3.14 } );
	is $tt._process( Q{[% constants.pi %]} ), '3.14';
}, Q{CONSTANTS};

subtest {
	plan 1;

	my $tt = Template::Toolkit.new(
		CONSTANTS_NAMESPACE => 'const',
		CONSTANTS => { pi => 3.14 }
	);

	# XXX I think a case is missing here.

	# User constants should be available in what was the TT namespace.
	#
	is $tt._process(
		Q{[% constants.pi %]},
		{ constants => { pi => 4 } }
	), '4';

	# Check that TT constants are still available in the new namespace.
	#
	is $tt._process( Q{[% const.pi %]} ), '3.14';
}, Q{CONSTANTS_NAMESPACE};

# XXX	has $.NAMESPACE;
# XXX	has $.PROCESS;
# XXX	has $.PRE_PROCESS;
# XXX	has $.POST_PROCESS;
# XXX	has $.WRAPPER;
# XXX	has $.ERROR;
# XXX	has $.EVAL_PERL;
# XXX	has $.OUTPUT;
# XXX	has $.OUTPUT_PATH;
# XXX	has $.STRICT;
# XXX	has $.DEBUG;
# XXX	has $.DEBUG_FORMAT;
# XXX	has $.CACHE_SIZE;
# XXX	has $.STAT_TTL;
# XXX	has $.COMPILE_EXT;
# XXX	has $.COMPILE_DIR;
# XXX	has $.PLUGINS;
# XXX	has $.PLUGIN_BASE;
# XXX	has $.LOAD_PERL;
# XXX	has $.FILTERS;
# XXX	has $.LOAD_TEMPLATES;
# XXX	has $.LOAD_PLUGINS;
# XXX	has $.LOAD_FILTERS;
# XXX	has $.TOLERANT;
# XXX	has $.SERVICE;
# XXX	has $.CONTEXT;
# XXX	has $.STASH;
# XXX	has $.PARSER;
# XXX	has $.GRAMMAR;

#my $TT = Template::Toolkit.new( ENCODING => 'KOI_8' );
#say $TT.perl;
#say $TT.see-encoding;

# vim: ft=perl6

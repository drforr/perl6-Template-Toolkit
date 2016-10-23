=begin pod

=begin NAME

Template::Toolkit - A drop-in replacement for Perl 5's TT library

=end NAME

=begin SYNOPSIS

#    # Mix Perl5-style options ('PRE_CHOMP') with modern Perl 6 pairs
#    #
#    my $tt = Template.new( PRE_CHOMP => 1, :post-chomp(True) );

    # Use the old Perl5-style hashref.
    #
    $tt.process( 'slurp-me.tt', { session => { name => 'Joe Bloggs' } } );

    # Or the modern Perl6 inline arguments.
    #
    $tt.process( 'slurp-me.tt', :session( :name('Joe Bloggs') ) );

=end SYNOPSIS

=begin DESCRIPTION

Mimicking the Perl 5 Template Toolkit library as closely as possible, though not bug-for-bug, this aims to let you use your old Perl 5 .tt files in Perl 6 web applications without having to rewrite both your Perl 5 code B<and> your Perl 5 template files.

=end DESCRIPTION

=begin UPGRADING

Existing Template Toolkit files should for the most part render correctly. I'll make sure that the default TT5 filters exist, so code such as C<[% foo | html %]> runs without changes. Templates that use the C<PERL> and C<RAWPERL> should still parse, but the code within the C<PERL> and C<RAWPERL> blocks won't be run. If you're a brave soul, you can convert your code to use the C<PERL6> and C<RAWPERL6> directives.

TT5 constructor options should work, with a few exceptions:

    * VIEWS - TT5 and TT6 internals will be radically different.
              There may be a similar implementation, but it won't look the same.
    * CONSTANTS - Will B<work>, but internally there won't be a Perl 6
                  version of the TT compiler, at least in the first iteration.
    * CONSTANTS_NAMESPACE - See above
    * NAMESPACES - This won't be implemented because it ties me to the TT5
                   "namespace" API.
    * ERROR - This will be left to future versions
    * EVAL_PERL - Will exist, but be unused, as compiling raw Perl 5 code in a
                  Perl 6 template is pointless. There may be an EVAL_PERL6
                  option later on, though.
    * DEBUG - Will exist, but function differently because it too is tied
              to the Perl 5 API.
    * CACHE_SIZE - Will be accepted, but not implemented.
                   I might do something with Redis later, but not for the first
                   version.
    * STAT_TTL - See above
    * COMPILE_EXT - See above
    * COMPILE_DIR - See above
    * LOAD_TEMPLATES - Tied too closely to the Perl 5 API
    * LOAD_PLUGINS - See above
    * LOAD_FILTERS - See above
    * SERVICE - See above
    * CONTEXT - See above
    * STASH - See above
    * PARSER - See above
    * GRAMMAR - See above

I may be judging LOAD_* a bit too harshly. There will be internal classes for Templates, Filters and Plugins, but they probably won't act in the same way as their TT5 counterparts. So while you could theoretically write drop-in replacements (especially for Filters and Plugins) they woudn't have the same API.

Which is to say they may very well exist and be exposed to the user, but you'd probably have to rewrite your existing plugins to make them work with the new system; probably better to write from scratch.

Stash, Parser and Grammar objects are a bit different. It's probably easier in Perl 6 to override and rewrite these, but I also think that anyone that is insane enough to modify my grammar is already competent enough to do their own version of this module, so I might just let them override just for the lolcats.

=end UPGRADING

=begin OPTIONS

=item ENCODING

The default is UTF-8, as is the case with all of Perl 6. 

As in Perl 5 Template Toolkit, you can set the output encoding using the C<ENCODING> option at creation time.

    my $tt = Template::Toolkit.new( ENCODING => 'Latin-1' );

The defa

=cut

=item OUTPUT

By default L<Template::Toolkit> prints to C<$*OUT>, just as in the Perl 5 version. You can also do roughly what you used to be able to do in the Perl 5 versions, with some slight syntactic changes. That is to say you can still print to alternate filehandles, print to files, copy the processed template to a string, add it to an array reference, or even just call a C<.print()> method. The rest of this block tells you how to do that in Perl 6.

To print to an open filehandle, just pass it as the C<OUTPUT> argument.

    my $fh = "foo".IO.open: :w;
    my $tt = Template::Toolkit.new( OUTPUT => $fh );

To print to a given filename, pass it as the C<OUTPUT> argument.

    my $filename = "foo.txt";
    my $tt = Template::Toolkit.new( OUTPUT => $filename );

To print to a string, pass a reference to the string as the C<OUTPUT> argument.

    my Str $output;
    my $tt = Template::Toolkit.new( OUTPUT => \( $output ) );

To add template contents to an array, pass a reference to the array as the C<OUTPUT> argument.

    my @output;
    my $tt = Template::Toolkit.new( OUTPUT => \@output );

You can also give C<OUTPUT> an object with a C<.print()> method, and it'll invoke C<.print()> on the instance you give it.

    class MyPrinter { method print( Str $str ) { print "[$str]" } }
    my $tt = Template::Toolkit.new( OUTPUT => MyPrinter.new );

=cut

=end OPTIONS

=begin OPTION_NOTES

=item CONSTANTS, CONSTANTS_NAMESPACE

Left in place for backwards compatibility, but since this is mainly to improve Perl 5 precompilation, it's not as much of a win in Perl 6.

=cut

=end OPTION_NOTES

=begin METHODS

=item process( Str $filename, $stashref )

Given a filename, prints out the .tt file populated with the given stash referene. This uses the original Perl5-style hash reference, rather than the new lists of pairs that Perl 6 offers us.

=item process6( Str $filename, ... )

=end METHODS

=end pod

class Template::Toolkit {
	use Template::Toolkit::Grammar;
	use Template::Toolkit::Actions;

	use Template::Toolkit::Internal::Constant;
	use Template::Toolkit::Internal::Directive::End;
	use Template::Toolkit::Internal::Directive::Foreach;
	use Template::Toolkit::Internal::Directive::If;
	use Template::Toolkit::Internal::Directive::Get;

	# The original Perl 5 configuration options
	#
	#`(
	has $.ENCODING;
	has $.START_TAG = '[%';
	has $.END_TAG = '%]';
	has $.OUTLINE_TAG = '';
	has $.TAG_STYLE = 'template';
	has $.PRE_CHOMP;
	has $.POST_CHOMP;
	has $.TRIM;
	has $.INTERPOLATE;
	has $.ANYCASE;
	has $.INCLUDE_PATH;
	has $.DELIMITER;
	has $.ABSOLUTE;
	has $.RELATIVE;
	has $.DEFAULT;
	has $.BLOCKS;
	has $.VIEWS;
	has $.AUTO_RESET = 1;
	has $.RECURSION;
	has $.VARIABLES;
	has $.PREDEFINE;
	has $.CONSTANTS;
	has $.CONSTANTS_NAMESPACE;
	has $.NAMESPACE;
	has $.PROCESS;
	has $.PRE_PROCESS;
	has $.POST_PROCESS;
	has $.WRAPPER;
	has $.ERROR;
	has $.EVAL_PERL;
	has $.OUTPUT;
	has $.OUTPUT_PATH;
	has $.STRICT;
	has $.DEBUG;
	has $.DEBUG_FORMAT;
	has $.CACHE_SIZE;
	has $.STAT_TTL;
	has $.COMPILE_EXT;
	has $.COMPILE_DIR;
	has $.PLUGINS;
	has $.PLUGIN_BASE;
	has $.LOAD_PERL;
	has $.FILTERS;

	# Deep customization
	has $.LOAD_TEMPLATES;
	has $.LOAD_PLUGINS;
	has $.LOAD_FILTERS;
	has $.TOLERANT;
	has $.SERVICE;
	has $.CONTEXT;
	has $.STASH;
	has $.PARSER;
	has $.GRAMMAR;
	)

	constant TAG-START = '[%';
	constant TAG-END = '%]';
	constant TAG-OUTLINE = '%%';

	my %tag-styles =
		template => [ TAG-START, TAG-END ],	# There's also a 'template1'
					# which has [% %] and %% %%.
		metatext => ['%%', '%%' ],
		star => ['[*', '*]' ],
		php => ['<?', '?>' ],
		asp => ['<%', '%>' ],
		mason => ['<%', '>' ],
		html => ['<!--', '-->' ];

	enum Chomp-Style <none one collapse greedy>; # 'all' == 'one'... Grr.

	has Str $!encoding = Q{utf8};	# ENCODING
	has %!tags =
		:start( TAG-START ),		# START_TAG
		:end( TAG-END ),		# END_TAG
		:outline( TAG-OUTLINE );	# OUTLINE_TAG
	has Bool $!use-outlines = False;
	has Bool $!use-scalar = False;	# INTERPOLATE

	has %!chomp =
		:pre( 0 ),		# PRE_CHOMP
		:post( 0 );		# POST_CHOMP
	has Bool $!trim = False;	# TRIM
	has Bool $!any-case = False;	# ANYCASE

	has Str $!delimiter = ':';	# DELIMITER

	has Bool $!absolute = False;	# ABSOLUTE
	has Bool $!relative = False;	# RELATIVE
	has %!blocks;			# BLOCKS
	has @!views;			# VIEWS (is either % or @ in perl5)
	has Bool $!auto-reset = True;	# AUTO_RESET
	has Bool $!recursion = False;	# RECURSION
	has %!variables;		# VARIABLES | PRE_DEFINE
	has %!constants;		# CONSTANTS
	has Str $!constant-namespace = 'constants';	# CONSTANT_NAMESPACE
	has %!namespace;		# NAMESPACE # XXX may ignore this?

	has Str @!include-path; # This could be complex...

	# Single template or delimited list
	#
	has Str @!pre-process;		# PRE_PROCESS
	has Str @!post-process;		# POST_PROCESS
	has Str @!process;		# PROCESS
	has Str @!wrapper;		# WRAPPER
	has %!error;			# ERROR ( string as well )
	has Bool $!eval-perl = False;	# EVAL_PERL
	has $!output = $*OUT;		# OUTPUT
	has $!output-path;		# OUTPUT_PATH
	has Bool $!strict = False;	# STRICT

	enum Debug-Style < SERVICE CONTEXT PROVIDER PLUGINS FILTERS
			   PARSER UNDEF DIRS ALL CALLER>;

	has Debug-Style $!debug;	# DEBUG
	has Str $!debug-format;		# DEBUG_FORMAT

	# Probably will be unimplemented
	#
#	has Int $!cache-size = 0;	# CACHE_SIZE
#	has Int $!stat-ttl = 0;		# STAT_TTL
#	has Str $!compile-ext;		# COMPILE_EXT
#	has Str $!compile-dir;		# COMPILE_DIR

	# Should be done
	#
	has %!plugins;			# PLUGINS
	has @!plugin-base;		# PLUGIN_BASE ( str or array )
	has Bool $!load-perl = False;	# LOAD_PERL
	has %!filters;			# FILTERS

	# Probably unimplemented, for various reasons.
	#
#	has $!load-templates;		# LOAD_TEMPLATES
#	has $!load-plugins;		# LOAD_PLUGINS
#	has $!load-filters;		# LOAD_FILTERS
#	has Bool $!tolerant = False;	# TOLERANT
#	has $!service;			# SERVICE
#	has $!context;			# CONTEXT
#	has $!stash;			# STASH
#	has $.parser;			# PARSER
#	has $.grammar;			# GRAMMAR

	submethod BUILD( *%args ) {
		$!encoding = %args<ENCODING> if %args<ENCODING>;

		%!tags<start> = %args<START_TAG> // TAG-START;
		%!tags<end> = %args<END_TAG> // TAG-END;
		%!tags<outline> = %args<OUTLINE_TAG> // TAG-OUTLINE;

		if %args<TAG_STYLE> {
			$!use-outlines = True if %args<TAG_STYLE> eq 'outline';
			if %tag-styles{%args<TAG_STYLE>} {
				%!tags<start> =
					%tag-styles{%args<TAG_STYLE>}[0];
				%!tags<end> =
					%tag-styles{%args<TAG_STYLE>}[1];
			}
		}

		$!use-outlines = True if %args<OUTLINE_TAG>;

		%!chomp<pre> = %args<PRE_CHOMP> // 0;
		%!chomp<post> = %args<POST_CHOMP> // 0;

		$!trim = True if
			%args<TRIM> and %args<TRIM> != 0;

		$!use-scalar = True if
			%args<INTERPOLATE> and %args<INTERPOLATE> != 0;

		$!any-case = True if
			%args<ANYCASE> and %args<ANYCASE> != 0;
		$!delimiter = %args<DELIMITER> if %args<DELIMITER>;
		$!absolute = True if
			%args<ABSOLUTE> and %args<ABSOLUTE> != 0;
		$!relative = True if
			%args<RELATIVE> and %args<RELATIVE> != 0;
		%!blocks = %( %args<BLOCKS> ) if %args<BLOCKS>;

		# XXX VIEWS

		$!auto-reset = True if
			%args<AUTO_RESET> and %args<AUTO_RESET> != 0;
		$!recursion = True if
			%args<RECURSION> and %args<RECURSION> != 0;
		%!variables = %( %args<VARIABLES> ) if %args<VARIABLES>;
		%!constants = %( %args<CONSTANTS> ) if %args<CONSTANTS>;
		$!constant-namespace = %args<CONSTANT_NAMESPACE> if
			%args<CONSTANT_NAMESPACE>;
		%!namespace = %( %args<NAMESPACE> ) if %args<NAMESPACE>;
		@!include-path = @( %args<INCLUDE_PATH> ) if # XXX needs work
			%args<INCLUDE_PATH>;
		@!pre-process = @( %args<PRE_PROCESS> ) if # XXX needs work
			%args<PRE_PROCESS>;
		@!post-process = @( %args<POST_PROCESS> ) if # XXX needs work
			%args<POST_PROCESS>;
		@!process = @( %args<PROCESS> ) if # XXX needs work
			%args<PROCESS>;
		@!wrapper = @( %args<WRAPPER> ) if # XXX needs work
			%args<WRAPPER>;
		# 'ERROR' or 'ERRORS'
		%!error = %( %args<ERROR> ) if %args<ERROR>;
		%!error = %( %args<ERRORS> ) if %args<ERRORS>;
		$!eval-perl = True if
			%args<EVAL_PERL> and %args<EVAL_PERL> != 0;
		$!output = %args<OUTPUT> if %args<OUTPUT>; # XXX complex
		$!output-path = %args<OUTPUT_PATH> if %args<OUTPUT_PATH>;
		$!strict = True if %args<STRICT> and %args<STRICT> != 0;
		$!debug = %args<DEBUG> if %args<DEBUG>; # XXX typed
		$!debug-format = %args<DEBUG_FORMAT> if %args<DEBUG_FORMAT>;

		# caching options, unimplemented here.
		# At least in the first version.

		%!plugins = %( %args<PLUGINS> ) if %args<PLUGINS>;
		@!plugin-base = @( %args<PLUGIN_BASE> ) if # XXX needs work
			%args<PLUGIN_BASE>;
		$!load-perl = True if
			%args<LOAD_PERL> and %args<LOAD_PERL> != 0;
		%!filters = %( %args<FILTERS> ) if %args<FILTERS>;

		# Other unimplemented stuff
	}

	my class Element {
		has Str $.content;
		has Int $.length;
	};

	# XXX They really only do one thing, maybe should be subtypes.
	#
	my class Element::Tag {
		also is Element;

		method to-directive( $g, $a ) {
			my @ast = $g.parse(
				self.content,
				:actions( $a )
			).ast;
			@ast
		}
	};

	my class Element::Text {
		also is Element;

		method to-directive( $g, $a ) {
			Template::Toolkit::Internal::Constant.new(
				:value-to-fetch(
					self.content
				)
			)
		}
	};

	method next-element( Str $string, Bool $is-first-text ) {
		return unless $string.defined;

		my $tag-start = %!tags.<start>;
		my $tag-end = %!tags.<end>;
		my $tag-outline = %!tags.<outline>;

		my regex scalar-name {
			<[ a .. z A .. Z ]> <[ a .. z A.. Z 0 .. 9 _ ]>*
		};
		my regex scalar-variable {
			\$
			(
			|	'{' <scalar-name>+ %% '.' '}'
			|	<scalar-name>
			)
		};
		my $loc-start = $string.index( $tag-start );
		my $loc-outline = $string.index( $tag-outline );
		my $loc-scalar = $string.index( '$' );
		my $inset = $string.chars;

		my @check =
			$string.chars;

		@check.append( $loc-start ) if $loc-start.defined;
		@check.append( $loc-outline ) if
			$!use-outlines and $loc-outline.defined;
		@check.append( $loc-scalar ) if
			$!use-scalar and $loc-scalar.defined;
		$inset = min( @check );

		if 0 < $inset <= $string.chars {
			my $loc-end = $string.index( $tag-end );
			if $loc-start.defined and
				$inset == $loc-start and
				( !$loc-end.defined or $loc-end < $loc-start ) {
				Element::Text.new(
					:content( $string ),
					:length( $string.chars )
				)
			}
			else {
				my $content = $string.substr( 0, $inset );
				given %!chomp<pre> {
					when 1 {
						$content ~~
							s{ [ \n \h* ]+ $ } = '';
					}
				}
				if !$is-first-text {
					given %!chomp<post> {
						when 1 {
							$content ~~
								s{ ^ [ \h* \n ]+ } = '';
						}
					}
				}
				Element::Text.new(
					:content( $content ),
					:length( $inset )
				)
			}
		}
		else {
			# [% "tag %]" %] is illegal.
			# [%# "tag %]" %] is a commented tag, and '" %]' is the
			# next tag in sequence.
			# [% # "tag %]" %] acts the same.
			# [%] is just a string.
			if $loc-start.defined and $loc-start == 0 {
				my $loc-end = $string.index( $tag-end );
				if $loc-end.defined and $loc-end > $tag-start.chars {
					my $content = 
						$string.substr(
							$tag-start.chars,
							$loc-end - $tag-start.chars
						);
					$content ~~ s{ ^ \s+ } = '';
					$content ~~ s{ \s+ $ } = '';
					Element::Tag.new(
						:content( $content ),
						:length(
							$loc-end + $tag-end.chars
						)
					)
				}
				else {
					Element::Text.new(
						:content( $string ),
						:length( $string.chars )
					)
				}
			}

			# 'foo\n%% 1\nbar' is 'foo1bar' even if only
			# PRE_CHOMP is set
			#
			elsif $!use-outlines and
				($loc-outline.defined and $loc-outline == 0) {
				my $loc-end = $string.index( "\n" );
				if $loc-end.defined and $loc-end > $tag-outline.chars {
					my $content = 
						$string.substr(
							$tag-outline.chars,
							$loc-end - $tag-outline.chars
						);
					$content ~~ s{ ^ \s+ } = '';
					Element::Tag.new(
						:content( $content ),
						:length( $loc-end + $tag-end.chars )
					)
				}
				elsif $loc-end.defined {
					die "Can't happen, tag start is '$tag-outline' and has a newline inside '$tag-outline'"
				}
				else {
					my $content = 
						$string.substr(
							$tag-outline.chars
						);
					$content ~~ s{ ^ \s+ } = '';
					Element::Tag.new(
						:content( $content ),
						:length( $string.chars )
					)
				}
			}
			elsif $!use-scalar and
				($loc-scalar.defined and $loc-scalar == 0) {
				$string ~~ m{ ^ <scalar-variable> };
				$/<scalar-variable>.chars,
				Element::Tag.new(
					:content(
						$/<scalar-variable>.Str
					),
					:length( $/<scalar-variable>.chars )
				)
			}
			else {
				die "Shouldn't get here!"
			}
		}
	}

	method _split( Str $string ) {
		my Element @element;
		my $inset = 0;
		while $inset < $string.chars {
			my $remainder = $string.substr( $inset );
			my $next-element = self.next-element(
				$remainder,
				@element.elems == 0
			);

			$inset += $next-element.length;
			@element.append(
				$next-element
			)
		}
#say @element.perl;
		@element
	}

	method _fold( Template::Toolkit::Internal @internal ) {
		my Template::Toolkit::Internal @result;
		my Template::Toolkit::Internal @stack;
		for @internal -> $internal {
			given $internal {
				when Template::Toolkit::Internal::Directive::If {
					@stack.push( $internal )
				}
				when Template::Toolkit::Internal::Directive::Foreach {
					@stack.push( $internal )
				}
				when Template::Toolkit::Internal::Constant {
					if @stack {
						@stack[*-1]._add-if-content(
							$internal
						)
					}
					else {
						@result.append( $internal )
					}
				}
				when Template::Toolkit::Internal::Directive::End {
					@result.append( @stack.pop )
				}
				default {
					@result.append( $internal )
				}
			}
		}
		@result
	}

	# For example:
	#	Text nodes return a closure that just returns the text.
	#	INSERT tags return a closure that opens the file,
	#	slurps and returns the contents.
	#
	method _parse( Element @element, $stashref ) {
		my $g = Template::Toolkit::Grammar.new;
		my $a = Template::Toolkit::Actions.new;
		my Template::Toolkit::Internal @directive;
		for @element {
			@directive.append(
				$_.to-directive( $g, $a )
			)
		}
		@directive
	}

	# _split( $string ) breaks $string into a sequence of tags and text.
	# _parse( @element ) turns elements into a sequence of directives.
	# _compile( @parsed ) turns directives into a sequence of routines.
	#
	# Then the routines get evaluated for their content.
	#
	method _process( Str $string, $stashref = { } ) {
		my Element @element = self._split( $string );
		my Template::Toolkit::Internal @directive =
			self._parse( @element, $stashref );
#say @directive.perl;
		my @folded = self._fold( @directive );
#say @folded.perl;
		my @routine = map { .compile }, @folded;
#say @routine.perl;

		my $text = join( '', map { .( $stashref ) }, @routine );
		if $!trim {
			$text ~~ s{ ^ \s+ } = '';
			$text ~~ s{ \s+ $ } = '';
		}
		$text
	}

	method process( $filename, $stashref = { }, Str :$output-file ) {
		my $template;
		if $filename ~~ Str {
			$filename.IO.e or die "Filename '$filename' not found!";
			$filename.IO.f or die "Filename '$filename' not a file!";
			$template = $filename.IO.slurp;
		}
		else {
			$template = $filename.[0];
		}

		my $res = self._process( $template, $stashref );
		if $*TESTING {
			return $res
		}
	
		# If the chosen output is an IO object (the default, STDOUT)
		# then just print to it.
		#
		if $!output ~~ IO {
			$!output.print( $res )
		}

		# If it's a string, then assume it's a file that we want to
		# print to, so open it and print to it.
		#
		elsif $!output.Str {
			my $fh = $!output.IO.open( :w );
			$fh.print( $res )
		}

		# It *could* be a reference to a string. If so, dereference it
		# and assign to the string.
		#
		elsif $!output ~~ Capture {
			$( $!output ) =  $res
		}

		# It could be a reference to an array. If so, push onto the
		# end of the array.
		#
		elsif $!output ~~ Array {
			$!output.push( $res )
		}

		# Otherwise, assume it's an object that has a .print method,
		#
		elsif $!output.^can( 'print' ) {
			$!output.print( $res )
		}

		# Otherwise, no idea what to do.
		#
		else {
			die Q{Couldn't identify OUTPUT};
		}
	}
}

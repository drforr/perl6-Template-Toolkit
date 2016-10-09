class Template::Toolkit::Actions {
	has $.stashref;

#`(
	method Positive-Integer( $/ ) {
		make +$/
	}
	method Integer( $/ ) {
		make +$/
	}
	method Floating-Point( $/ ) {
		make +$/
	}

	method Function-Name( $/ ) {
		make ~$/
	}
	method Path( $/ ) {
		make ~$/
	}
	token Path-Name
		{
		| <String>
		| <Path>+ %% '/'
		}

	rule Pair
		{
		| <[ a .. z ]>+ '=>' <Expression>
		}

	token Argument
		{
		| <Pair>
		| <String>
		| 'd' '=' 'e'
		| 'f' '=' 'g'
		| <[ a .. z ]>+
		| <Integer>
		}

	method Function-Call( $/ ) {
#		| <Function-Name>
#		  [ '(' [ <Argument>* %% [ ',' | \s+ ] | <Argument>* ] ')' ]?
#		| <Positive-Integer>
		make "NOT READY"
	}

	method Value( $/ ) {
		make $/<Integer>.ast || $/<Floating-Point>.ast || $/<String>.ast || $/<Function-Call>>>.ast
	}

	method Plugin-Name( $/ ) {
		make ~$/
	}
	method String( $/ ) {
		make ~$/
	}

#	# In TT, AND and && are the same precedence and meaning.
#	#
#	token And { 'AND' | '&&' }

#	# In TT, OR and || are the same precedence and meaning.
#	#
#	token Or { 'OR' | '||' }

#	# In TT, NOT and ! are the same precedence and meaning.
#	#
#	token Not { 'NOT' | '!' }

#	token Equals { '==' | '!=' }

#	token Compared-To
#		{
#		| '<'  | 'lt'
#		| '<=' | 'le'
#		| '=<' | 'ge'
#		| '>'  | 'gt'
#		}

#	# / and 'div' are semantically different, not syntactically.
#	#
#	token Plus { '+' | '-' }
#	token Times { '*' | '/' | 'DIV' | 'div' }
#	token Modulo { '%' | 'MOD' | 'mod' }

	method Expression( $/ ) {
		make $/<Value>.ast
	}

	token Block-Name
		{
		| [ <[ a .. z ]> <[ a .. z 0 .. 9 _ ]>* ]+ %% ':'
		| <String>
		}

	method Named-Parameter( $/ ) {
		make [ $/<Value>.ast, $/<Expression>.ast ]
	}
)

	my class Stash-Value {
		has $.value-to-fetch;
		method compile( $stashref ) {
			sub ( $stashref ) { $stashref.{$.value-to-fetch} // '' }
		}
	}

	method Function-Call( $/ ) {
		make Stash-Value.new( :value-to-fetch( ~$/<Function-Name> ) )
	}

	my class Constant {
		has $.value-to-fetch;
		method compile( $stashref ) {
			sub ( $stashref ) { $.value-to-fetch }
		}
	}

#	method Positive-Integer( $/ ) {
#	}

	method Integer( $/ ) {
		make Constant.new( :value-to-fetch( +$/ ) )
	}

	method String( $/ ) {
		make Constant.new( :value-to-fetch( ~$/[0] ) )
	}

	method Value( $/ ) {
		make
			$/<Integer>.ast ||
			$/<String>.ast ||
			$/<Function-Call>[0].ast
	}

# From the output of $/.gist, it is *not* obvious that I have to use an
# array accessor to get to the Nth value
#
#｢-6｣
# Directive-Get => ｢-6｣
#  Expression => ｢-6｣
#   Value => ｢-6｣
#    Integer => ｢-6｣
#     Positive-Integer => ｢6｣

	method Expression( $/ ) {
say $/.gist;
		make $/<Value>[0].ast
	}

	method Directive-Get( $/ ) {
say $/.gist;
		make $/<Expression>.ast
	}

	method Directive( $/ ) {
say $/.gist;
		make $/<Directive-Get>.ast
	}

	# The constant chaining of 'make...' seems redundant to me.
	method TOP( $/ ) {
say $/.gist;
say $/<Directive>[0].ast.perl;
		make $/<Directive>[0].ast
	}
}

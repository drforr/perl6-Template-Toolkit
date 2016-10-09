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

	my class Directive::Get {
		has $.value-to-fetch;
		method compile( $stashref ) {
			sub ( $stashref ) { $.value-to-fetch }
		}
	}

	method Directive-Get( $/ ) {
		make Directive::Get.new(
			:value-to-fetch( ~$/<Expression> )
		)
	}

	method Directive( $/ ) {
#say ~$/.gist;
		make $/<Directive-Get>.ast
	}

	method TOP( $/ ) {
#say "Compiling with stashref of {$.stashref.perl}";
		make $/<Directive>>>.ast
	}
}

grammar Template::Toolkit::Grammar
	{
	token Positive-Integer
		{
		| <[ 1 .. 9 ]> <[ 0 .. 9 ]>*
		| '0'
		}
	token Integer
		{
		| '-'? <Positive-Integer>
		}
	token Floating-Point
		{
		| '-'? <[ 1 .. 9 ]> <[ 0 .. 9 ]>* '.' <[ 0 .. 9 ]>+
		| '-'? '0' '.' <[ 0 .. 9 ]>+
		}

	token Function-Name
		{
		| <[ a .. z A .. Z ]> <[ a .. z A .. Z 0 .. 9 _ ]>*
		}
	token Path
		{
		| <[ a .. z ]> <[ a .. z 0 .. 9 _ ]>*
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

	rule Function-Call
		{
		| <Function-Name>
		  [ '(' [ <Argument>* %% [ ',' | \s+ ] | <Argument>* ] ')' ]?
		| <Positive-Integer>
		}

	rule Value
		{
		| <Function-Call>+ %% '.'
		| <String>
		| <Floating-Point>
		| <Integer>
		}

	token Plugin-Name
		{
		| <[ a .. z ]>+
		}
	token String
		{
		| \" [ <-[ " \\ ]> | '\\' . ]* \"
		| \' [ <-[ ' \\ ]> | '\\' . ]* \'
		}

	# In TT, AND and && are the same precedence and meaning.
	#
	token And { 'AND' | '&&' }

	# In TT, OR and || are the same precedence and meaning.
	#
	token Or { 'OR' | '||' }

	# In TT, NOT and ! are the same precedence and meaning.
	#
	token Not { 'NOT' | '!' }

	token Equals { '==' | '!=' }

	token Compared-To
		{
		| '<'  | 'lt'
		| '<=' | 'le'
		| '=<' | 'ge'
		| '>'  | 'gt'
		}

	# / and 'div' are semantically different, not syntactically.
	#
	token Plus { '+' | '-' }
	token Times { '*' | '/' | 'DIV' | 'div' }
	token Modulo { '%' | 'MOD' | 'mod' }

	rule Array
		{
		| '[' <String>+ %% ',' ']'
		| '[' <Integer>+ %% \s+ ']'
		}

	rule Expression
		{
		| <Value> <Times> <Value> <Plus> <Value> <Times> <Value>
		| <Value> <Or> <Value> <Or> <Value> <Or> <Value>
		| <Value> <Plus> <Value> <Times> <Value>
		| <Value> <And> <Value> <Or> <Value>
		| <Value> <And> <Value> <Or> <Value>
		| <Value> <And> <Value>
		| <Value> <Or> <Value>
		| <Value> <Compared-To> <Value>
		| <Value> <Equals> <Value>
		| <Value> <Plus> <Value>
		| <Value> <Times> <Value>
		| <Value> <Modulo> <Value>
		| <Not> <Value>
		| <Value>
		| <Array>
		}

	token Block-Name
		{
		| [ <[ a .. z ]> <[ a .. z 0 .. 9 _ ]>* ]+ %% ':'
		| <String>
		}

	rule Named-Parameter
		{
		| <Value> '=' <Expression>
		}

	# Broken out for easier Action coding.
	# Specifically, I don't need to create aliases and switch on
	# whether 'BLOCK' was found as the first match.
	#
	rule Directive-Block
		{
		| 'BLOCK'
			(
			| <Named-Parameter>+
			| <Block-Name> <Named-Parameter>*
			)
		}
	rule Directive-Catch { 'CATCH' }
	rule Directive-Get { 'GET'? <Expression> }
	rule Directive-Foreach { 'FOREACH' <Value> '=' <Expression> }
	rule Directive-If
		{
		| 'IF' <Expression>
		| <Value> '=' 'IF' <Expression>
		}
	rule Directive-Include
		{
		| 'INCLUDE' <Path-Name> <Named-Parameter>*
		| <Value> '=' 'INCLUDE' <Path-Name> <Named-Parameter>*
		}
	rule Directive-Else { 'ELSE' }
	rule Directive-Elsif { 'ELSIF' <Expression> }
	rule Directive-End { 'END' }
	rule Directive-Meta { 'META' <Pair>+ }
	rule Directive-Process
		{
		| 'PROCESS' <Path-Name>
		| <Value> '=' 'PROCESS' <Path-Name>
		}
	rule Directive-Set { 'SET' <Value> '=' <Expression> } # Hrm.
	rule Directive-Try { 'TRY' }
	rule Directive-Unless
		{
		| 'UNLESS' <Expression>
		| <String> 'UNLESS' <Expression>
		}
	rule Directive-Use
		{
		| 'USE'
			(
			| <Plugin-Name> '=' <Function-Call>
			| <Function-Call>
			| <Plugin-Name>
			)
		}

	rule Directive
		{
		| <Directive-Block>
		| <Directive-Catch>
		| <Directive-Foreach>
		| <Directive-Get>
		| <Directive-If>
		| <Directive-Include>
		| <Directive-Else>
		| <Directive-Elsif>
		| <Directive-End>
		| <Directive-Meta>
		| <Directive-Process>
		| <Directive-Set>
		| <Directive-Try>
		| <Directive-Unless>
		| <Directive-Use>
		| <Value> '=' <Expression>
		}

	rule TOP
		{
		| [ <Directive> ';'? ]+
		}
	}

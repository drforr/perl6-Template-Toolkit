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

	rule Expression
		{
		| '[' <String>+ %% ',' ']'
		| '[' <Integer>+ %% \s+ ']'
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

	rule Directive
		{
		(
		| 'BLOCK'
			(
			| <Named-Parameter>+
			| <Block-Name> <Named-Parameter>*
			)
		| 'CATCH'
		| 'FOREACH' <Value> '=' <Expression>
		| 'GET'? <Expression>
		| 'IF' <Expression>
		| 'INCLUDE' <Path-Name> <Named-Parameter>*
		| 'ELSE'
		| 'ELSIF' <Expression>
		| 'END'
		| 'META' <Pair>+
		| 'PROCESS' <Path-Name>
		| 'SET' <Value> '=' <Expression>
		| 'TRY'
		| 'UNLESS' <Expression>
		| 'USE'
			(
			| <Plugin-Name> '=' <Function-Call>
			| <Function-Call>
			| <Plugin-Name>
			)
		| <String> 'UNLESS' <Expression>
		| <Value> '='
			(
			| 'IF' <Expression>
			| 'INCLUDE' <Path-Name> <Named-Parameter>*
			| 'PROCESS' <Path-Name>
			| <Expression>
			)
		)
		';'?
		}

	rule TOP
		{
		| <Directive>+
		}
	}

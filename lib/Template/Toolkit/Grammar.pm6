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

	token Function-Name
		{
		| <[ a .. z ]>+
		}
	token Path
		{
		| <[ a .. z ]> <[ a .. z 0 .. 9 ]>*
		}
	token Path-Name
		{
		| <Path>+ %% '/'
		}

	token Argument
		{
		| '"\\n"'
		| 'd' '=' 'e'
		| 'f' '=' 'g'
		| <[ a .. z ]>+
		}

	rule Function-Call
		{
		| <Function-Name>  '(' <Argument>+ %% [ ',' | \s+ ] ')'
		| <Function-Name>
		| <Positive-Integer>
		}

	rule Value
		{
		| <Function-Call>+ %% '.'
		| <String>
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

	rule Directive
		{
		#| 'SET'? <Value> '=' <Expression>
		| 'CATCH'
		| 'GET'? <Expression>
		| 'GET'? <String>
		| 'IF' <Expression>
		| 'INCLUDE' <Path-Name>
		| 'ELSE'
		| 'ELSIF' <Expression>
		| 'END'
		| <String> 'UNLESS' <Expression>
		| 'UNLESS' <Expression>
		| 'USE' <Plugin-Name>
		| 'TRY'
		}

	rule TOP
		{
		| ( <Value> '=' <Expression> )+
		| <Directive>+ %% [ ';' | \n ]
		}
	}

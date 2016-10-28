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

	rule Package-Name
		{
		| <Function-Name>
		  '(' [ <Argument>* %% [ ',' | \s+ ] | <Argument>* ] ')'
		| <Function-Name>
		| <Positive-Integer>
		}

	rule Constant
		{
		| <Integer>
		| <String>
		| <Floating-Point>
		}

	rule Variable-Start
		{
		| <Function-Name>
		  '(' [ <Argument>* %% [ ',' | \s+ ] | <Argument>* ] ')'
		| <Function-Name>
		}

	rule Variable-Element
		{
		| <Variable-Start>
		| <Positive-Integer>
		}

	rule Variable
		{
		| <Variable-Start> '.' <Variable-Element>+ %% '.'
		| <Variable-Start>
		}

	token Plugin-Name
		{
		| <[ a .. z ]>+
		}
	# The () are needed to let the actions easily capture the text.
	token String
		{
		| \" ( [ <-[ " \\ ]> | '\\' . ]* ) \"
		| \' ( [ <-[ ' \\ ]> | '\\' . ]* ) \'
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
		| <Variable> <Times> <Constant> <Plus> <Constant> <Times> <Constant>
		| <Variable> <Or> <Variable> <Or> <Variable> <Or> <Variable>
		| <Variable> <Plus> <Constant> <Times> <Constant>
		| <Variable> <And> <Variable> <Or> <Variable>
		| <Variable> <And> <Variable> <Or> <Variable>
		| <Variable> <And> <Variable>
		| <Variable> <Or> <Variable>
		| <Variable> <Compared-To> <Variable>
		| <Variable> <Equals> <Constant>
		| <Variable> <Plus> <Variable>
		| <Variable> <Times> <Variable>
		| <Variable> <Modulo> <Variable>
		| <Not> <Variable>
		| <Variable>
		| <Constant>
		| <Array>
		}

	token Block-Name
		{
		| [ <[ a .. z ]> <[ a .. z 0 .. 9 _ ]>* ]+ %% ':'
		| <String>
		}

	rule Named-Parameter
		{
		| <Variable> '=' <Expression>
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
	rule Directive-Foreach
		{
		| 'FOREACH' <Variable> '=' <Expression>
		| 'FOREACH' <Expression>
		}
	rule Directive-If
		{
		| 'IF' <Expression>
		| <Variable> '=' 'IF' <Expression>
		}
	rule Directive-Include
		{
		| 'INCLUDE' <Path-Name> <Named-Parameter>*
		| <Variable> '=' 'INCLUDE' <Path-Name> <Named-Parameter>*
		}
	rule Directive-Else { 'ELSE' }
	rule Directive-Elsif { 'ELSIF' <Expression> }
	rule Directive-End { 'END' }
	rule Directive-Meta { 'META' <Pair>+ }
	rule Directive-Process
		{
		| 'PROCESS' <Path-Name>
		| <Variable> '=' 'PROCESS' <Path-Name>
		}
	rule Directive-Set { 'SET' <Variable> '=' <Expression> }
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
			| <Plugin-Name> '=' <Package-Name>
			| <Package-Name>
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
		| <Variable> '=' <Expression>
		}

	rule TOP
		{
		| [ <Directive> ';'? ]+
		}
	}

grammar Template::Toolkit::Grammar
	{
	token Integer
		{
		| <[ 1 .. 9 ]> <[ 0 .. 9 ]>*
		}

	token Function-Name
		{
		| <[ a .. z ]>+
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
		| <Integer>
		}

	rule TOP
		{
		| <Function-Call>+ %% '.'
		}
	}

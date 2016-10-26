use Template::Toolkit::Internal;
class Template::Toolkit::Internal::Constant
	is Template::Toolkit::Internal {

	has $.value-to-fetch;
	method compile( ) {
		sub ( $stashref ) { $.value-to-fetch }
	}

	method fold(
		Template::Toolkit::Internal @stack,
		Template::Toolkit::Internal @result ) {
		if @stack {
			@stack[*-1]._add-tag( self )
		}
		else {
			@result.append( self )
		}
	}
}

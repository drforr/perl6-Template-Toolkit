use Template::Toolkit::Internal;
class Template::Toolkit::Internal::Constant
	is Template::Toolkit::Internal {

	has $.value-to-fetch;
	method compile( ) {
		sub ( $stashref ) { $.value-to-fetch }
	}
}

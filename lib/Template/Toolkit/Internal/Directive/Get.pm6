use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::Get
	is Template::Toolkit::Internal::Directive {

	has $.value-to-fetch;
	method compile( ) {
		sub ( $stashref ) { $stashref.{$.value-to-fetch} // '' }
	}
}

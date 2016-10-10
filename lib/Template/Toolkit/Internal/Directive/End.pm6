use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::End
	is Template::Toolkit::Internal::Directive {

	method compile( ) {
		sub ( $stashref ) { }
	}
}

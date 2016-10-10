use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::Stash-Method
	is Template::Toolkit::Internal::Directive {

	has $.method-to-call;
	has @.argument;
	method compile( ) {
		sub ( $stashref ) { $stashref.{$.method-to-call}.(|@.argument) // '' }
	}
}

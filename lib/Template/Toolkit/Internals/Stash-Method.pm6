class Template::Toolkit::Internals::Stash-Method {
	has $.method-to-call;
	has @.argument;
	method compile( $stashref ) {
		sub ( $stashref ) { $stashref.{$.method-to-call}.(|@.argument) // '' }
	}
}

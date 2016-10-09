class Template::Toolkit::Internals::Stash-Value {
	has $.value-to-fetch;
	method compile( $stashref ) {
		sub ( $stashref ) { $stashref.{$.value-to-fetch} // '' }
	}
}

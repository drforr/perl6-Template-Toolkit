class Template::Toolkit::Internals::Constant {
	has $.value-to-fetch;
	method compile( $stashref ) {
		sub ( $stashref ) { $.value-to-fetch }
	}
}

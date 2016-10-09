class Template::Toolkit::Internals::End {
	method compile( $stashref ) {
		sub ( $stashref ) { }
	}
}

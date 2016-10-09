class Template::Toolkit::Internals::Conditional {
	has $.if-condition;
	has $.if-content; # Gets filled in later in some cases.
	method _add-if-content( Str $content ) {
		$!if-content = $content
	}
	method compile( $stashref ) {
		sub ( $stashref ) {
			if $.if-condition {
				$.if-content
			}
		}
	}
}

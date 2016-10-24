use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::If 
	is Template::Toolkit::Internal::Directive {

	has $.if-condition;
	has @.if-content; # Gets filled in later in most cases.
	method _add-if-content( Template::Toolkit::Internal $content ) {
		@!if-content.append( $content )
	}
	method compile( ) {
		sub ( $stashref ) {
			if $.if-condition.compile.($stashref) {
				join( '',
					map { .compile.($stashref) },
					@.if-content
				)
			}
			else {
				''
			}
		}
	}
}

use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::If 
	is Template::Toolkit::Internal::Directive {

	has $.if-condition;
	has $.if-content; # Gets filled in later in most cases.
	method _add-if-content( Str $content ) {
		$!if-content = $content
	}
	method compile( ) {
		sub ( $stashref ) {
			if $.if-condition.compile.($stashref) {
				$.if-content
			}
		}
	}
}

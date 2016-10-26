use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::Foreach 
	is Template::Toolkit::Internal::Directive {

	has $.iterator;
	has $.data;
	method _add-data( $data ) {
		$!data = $data
	}
	method compile( ) {
		sub ( $stashref ) {
#			if $.if-condition.compile.($stashref) {
#				$.if-content
#			}
		}
	}

	method fold(
		Template::Toolkit::Internal @stack,
		Template::Toolkit::Internal @result ) {
		@stack.push( self )
	}
}

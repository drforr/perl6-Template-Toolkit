use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::End
	is Template::Toolkit::Internal::Directive {

	method compile( ) {
		sub ( $stashref ) { }
	}

	method fold(
		Template::Toolkit::Internal @stack,
		Template::Toolkit::Internal @result ) {
		@result.append( @stack.pop )
	}
}

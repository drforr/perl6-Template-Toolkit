use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::Else
	is Template::Toolkit::Internal::Directive {

	method fold(
		Template::Toolkit::Internal @stack,
		Template::Toolkit::Internal @result ) {
		@stack[*-1].populate-default()
	}
}

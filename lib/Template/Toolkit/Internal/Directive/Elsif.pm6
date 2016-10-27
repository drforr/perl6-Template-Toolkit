use Template::Toolkit::Internal::Clause;
use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::Elsif 
	is Template::Toolkit::Internal::Directive {

	has Template::Toolkit::Internal::Clause $.clause;

	method fold(
		Template::Toolkit::Internal @stack,
		Template::Toolkit::Internal @result ) {
		@stack[*-1].add-clause( self.clause )
	}
}

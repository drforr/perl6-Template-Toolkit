use Template::Toolkit::Internal;
class Template::Toolkit::Internal::Clause
	is Template::Toolkit::Internal {

	has $.condition;
	has @.body;

	method evaluate( $stashref ) {
		join( '',
			map { .compile.($stashref) },
			@.body
		)
	}
}

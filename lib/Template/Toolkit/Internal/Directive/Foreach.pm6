use Template::Toolkit::Internal::Clause;
use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::Foreach 
	is Template::Toolkit::Internal::Directive {

	has $.topic;
	has $.iterator;
	has @.body;

	method _add-tag( Template::Toolkit::Internal $content ) {
		@.body.append( $content )
	}
	method compile( ) {
		sub ( $stashref ) {
			my $iterator = $.iterator.compile.($stashref);
			my $res = '';
			if $iterator ~~ Array {
				for @( $iterator ) {
					$res ~= join( '',
						map { .compile.($stashref) },
						@.body
					)
				}
			}
			elsif $iterator {
				$res ~= join( '',
					map { .compile.($stashref) },
					@.body
				)
			}
			$res
		}
	}

	method fold(
		Template::Toolkit::Internal @stack,
		Template::Toolkit::Internal @result ) {
		@stack.push( self )
	}
}

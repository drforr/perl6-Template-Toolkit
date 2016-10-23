use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::Get
	is Template::Toolkit::Internal::Directive {

	has $.value-to-fetch;
	has @.argument;
	method compile( ) {
		sub ( $stashref ) {
			if $stashref.{$.value-to-fetch} {
				if $stashref.{$.value-to-fetch} ~~ Routine {
					$stashref.{$.value-to-fetch}.(|@.argument) // ''
				}
				else {
					$stashref.{$.value-to-fetch} // ''
				}
			}
			else {
				''
			}
		}
	}
}

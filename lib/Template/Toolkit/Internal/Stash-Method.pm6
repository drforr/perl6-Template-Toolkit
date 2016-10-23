use Template::Toolkit::Internal;
class Template::Toolkit::Internal::Stash-Method
	is Template::Toolkit::Internal {

	has $.method-to-call;
	has @.argument;
	method compile( ) {
		sub ( $stashref ) {
			if $stashref.{$.method-to-call} {
				if $stashref.{$.method-to-call} ~~ Routine {
					$stashref.{$.method-to-call}.(|@.argument) // ''
				}
				else {
					$stashref.{$.method-to-call} // ''
				}
			}
			else {
				''
			}
		}
	}
}

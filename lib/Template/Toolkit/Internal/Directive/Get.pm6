use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::Get
	is Template::Toolkit::Internal::Directive {

	has $.value-to-fetch;
	has @.filter-to-run;
	has @.argument;
	method compile( ) {
		sub ( $stashref ) {
			if @.filter-to-run {
				my $temp = $stashref;
				for @.filter-to-run {
					$temp = $_.( $temp )
				}
				return $temp
			}
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

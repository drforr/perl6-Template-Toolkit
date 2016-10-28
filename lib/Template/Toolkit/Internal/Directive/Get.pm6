use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::Get
	is Template::Toolkit::Internal::Directive {

	has @.filter-to-run;
	method compile( ) {
		sub ( $stashref ) {
			if @.filter-to-run {
				my $temp = $stashref;
				for @.filter-to-run {
					$temp = $_.( $temp )
				}
				return $temp
			}
		}
	}

	method fold(
		Template::Toolkit::Internal @stack,
		Template::Toolkit::Internal @result ) {
		if @stack {
			@stack[*-1]._add-tag( self )
		}
		else {
			@result.append( self )
		}
	}
}

use Template::Toolkit::Internal::Clause;
use Template::Toolkit::Internal::Directive;
class Template::Toolkit::Internal::Directive::If 
	is Template::Toolkit::Internal::Directive {

	# A bit of a wart, $.in-main keeps track of where tags should go.
	# By default they're added to the last clause, which in general
	# is the right thing to do - Until an 'ELSIF' or 'ELSE' is encountered,
	# tags should be accumulated as part of the IF clause.
	#
	# Pushing a new dependent clause means that the tags are now part
	# of the ELSIF conditional, and so on until all of the ELSIF
	# clauses are used up.
	#
	# Finally, since ELSE doesn't have a condition associated with it, we
	# just call 'populate-default' to tell this object to start populating
	# the default ('ELSE') clause.
	# 
	# Notionally:
	#
	# IF 1 ; --> Initialize, treat '1' as the condition.
	# "foo" ; --> add-tag() populates @.clause[0].body
	# 2 ; --> The second.
	# ELSIF 42; --> Create a new clause with 42 as the condition.
	# "tag" ; --> add-tag()) populates @.class[1].body
	# ELSE ; --> Switch to populating the default tag.
	# "foo" ; --> Goes into @.default
	# END ; --> And we're spent.
	#
	has Bool $.in-main = True;
	has Template::Toolkit::Internal::Clause @.clause;
	has Template::Toolkit::Internal @.default;

	method _add-tag( Template::Toolkit::Internal $content ) {
		if $.in-main {
			@.clause[*-1].body.append( $content )
		}
		else {
			@.default.append( $content )
		}
	}
	method populate-default( ) {
		$!in-main = False;
	}
	method add-clause( Template::Toolkit::Internal::Clause $clause ) {
		@.clause.append( $clause )
	}
	method compile( ) {
		sub ( $stashref ) {
			for @.clause {
				if $_.condition.compile.($stashref) {
					return $_.evaluate($stashref)
				}
			}
			if @.default {
				join( '',
					map { .compile.($stashref) },
					@.default
				)
			}
			else {
				''
			}
		}
	}
}

class Template::Toolkit::Actions {
	has $.stashref;

	use Template::Toolkit::Internal::Constant;
	use Template::Toolkit::Internal::Directive::End;
	use Template::Toolkit::Internal::Directive::If;
	use Template::Toolkit::Internal::Directive::Get;

	# Arguments might have to return to being objects due to stashrefs.
	method Argument( $/ ) {
		make	+$/<Integer> ||
			~$/<String>[0]
	}

	method Function-Call( $/ ) {
		if $/<Argument> {
			make Template::Toolkit::Internal::Directive::Get.new(
				:value-to-fetch( ~$/<Function-Name> ),
				:argument( $/<Argument>>>.ast )
			)
		}
		elsif $/<Function-Name> {
			make Template::Toolkit::Internal::Directive::Get.new(
				:value-to-fetch( ~$/<Function-Name> )
			)
		}
		elsif $/<Positive-Integer> {
die "Whoops, fix this later"
		}
		else {
die "Unknown case, shouldn't happen"
		}
	}

	method Integer( $/ ) {
		make Template::Toolkit::Internal::Constant.new(
			:value-to-fetch( +$/ )
		)
	}

	method String( $/ ) {
		make Template::Toolkit::Internal::Constant.new(
			:value-to-fetch( ~$/[0] )
		)
	}

	method Constant( $/ ) {
		make
			$/<Integer>.ast ||
			$/<String>.ast ||
			$/<Floating-Point>.ast
	}

	method Variable-Start( $/ ) {
		if $/<Argument> {
			make Template::Toolkit::Internal::Directive::Get.new(
				:value-to-fetch( ~$/<Function-Name> ),
				:argument( $/<Argument>>>.ast )
			)
		}
		else {
			make Template::Toolkit::Internal::Directive::Get.new(
				:value-to-fetch( ~$/<Function-Name> )
			)
		}
	}

	method Variable-Element( $/ ) {
		make
			$/<Variable-Start>[0].ast ||
			$/<Positive-Integer>.ast
	}

	method Variable( $/ ) {
		make
			$/<Variable-Start>.ast # XXX *HORRIBLY* broken.
	}

# From the output of $/.gist, it is *not* obvious that I have to use an
# array accessor to get to the Nth value
#
#｢-6｣
# Directive-Get => ｢-6｣
#  Expression => ｢-6｣
#   Value => ｢-6｣
#    Integer => ｢-6｣
#     Positive-Integer => ｢6｣

	method Expression( $/ ) {
		# XXX The [0] may go away later, in which case so can the given.
		given $/ {
			when $_<Constant> {
				make $_<Constant>[0].ast
			}
			when $_<Variable> {
#say $_.gist;
				make $_<Variable>[0].ast
			}
		}
	}

	method Directive-Get( $/ ) {
		make $/<Expression>.ast
	}

	method Directive-End( $/ ) {
		make Template::Toolkit::Internal::Directive::End.new
	}

	# IF normally won't have values immediately after it.
	# We'll account for those later in testing.
	#
	method Directive-If( $/ ) {
		make Template::Toolkit::Internal::Directive::If.new(
			:if-condition( $/<Expression>.ast )
		)
	}

	method Directive-Foreach( $/ ) {
		make Template::Toolkit::Internal::Directive::Foreach.new(
			:iterator( $/<Value>.ast ),
			:data( $/<Expression> )
		)
	}

	method Directive( $/ ) {
		make
			$/<Directive-Get>.ast ||
			$/<Directive-Foreach>.ast ||
			$/<Directive-If>.ast ||
			$/<Directive-End>.ast
	}

	# The constant chaining of 'make...' seems redundant to me.
	method TOP( $/ ) {
		make $/<Directive>[0].ast
	}
}

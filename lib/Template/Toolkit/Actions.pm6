class Template::Toolkit::Actions {
	has $.stashref;

	use Template::Toolkit::Internals::Stash-Value;
	use Template::Toolkit::Internals::Stash-Method;
	use Template::Toolkit::Internals::Conditional;
	use Template::Toolkit::Internals::Constant;
	use Template::Toolkit::Internals::End;

	# Arguments might have to return to being objects due to stashrefs.
	method Argument( $/ ) {
		make +$/<Integer> ||
			~$/<String>[0]
	}

	method Function-Call( $/ ) {
		if $/<Argument> {
			make Template::Toolkit::Internals::Stash-Method.new(
				:method-to-call( ~$/<Function-Name> ),
				:argument( $/<Argument>>>.ast )
			)
		}
		else {
			make Template::Toolkit::Internals::Stash-Value.new(
				:value-to-fetch( ~$/<Function-Name> )
			)
		}
	}

	method Integer( $/ ) {
		make Template::Toolkit::Internals::Constant.new(
			:value-to-fetch( +$/ )
		)
	}

	method String( $/ ) {
		make Template::Toolkit::Internals::Constant.new(
			:value-to-fetch( ~$/[0] )
		)
	}

	method Value( $/ ) {
		make
			$/<Integer>.ast ||
			$/<String>.ast ||
			$/<Function-Call>[0].ast
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
		make $/<Value>[0].ast
	}

	method Directive-Get( $/ ) {
		make $/<Expression>.ast
	}

	method Directive-End( $/ ) {
		make Template::Toolkit::Internals::End.new
	}

	# IF normally won't have values immediately after it.
	# We'll account for those later in testing.
	#
	method Directive-If( $/ ) {
		make Template::Toolkit::Internals::Conditional.new(
			:if-condition( $/<Expression>[0]<Value> )
		)
	}

	method Directive( $/ ) {
		make
			$/<Directive-Get>.ast ||
			$/<Directive-If>.ast ||
			$/<Directive-End>.ast
	}

	# The constant chaining of 'make...' seems redundant to me.
	method TOP( $/ ) {
		make $/<Directive>[0].ast
	}
}

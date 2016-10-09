class Template::Toolkit::Actions {
	has $.stashref;

	my class Stash-Value {
		has $.value-to-fetch;
		method compile( $stashref ) {
			sub ( $stashref ) { $stashref.{$.value-to-fetch} // '' }
		}
	}

	my class Stash-Method {
		has $.method-to-call;
		has @.argument;
		method compile( $stashref ) {
			sub ( $stashref ) { $stashref.{$.method-to-call}.(|@.argument) // '' }
		}
	}

	method Argument( $/ ) {
		make +$/<Integer> ||
			~$/<String>[0] # Note we don't wrap argument values.
	}

	method Function-Call( $/ ) {
		if $/<Argument> {
			make Stash-Method.new(
				:method-to-call( ~$/<Function-Name> ),
				:argument( $/<Argument>>>.ast )
			)
		}
		else {
			make Stash-Value.new(
				:value-to-fetch( ~$/<Function-Name> )
			)
		}
	}

	my class Constant {
		has $.value-to-fetch;
		method compile( $stashref ) {
			sub ( $stashref ) { $.value-to-fetch }
		}
	}

#	method Positive-Integer( $/ ) {
#	}

	method Integer( $/ ) {
		make Constant.new( :value-to-fetch( +$/ ) )
	}

	method String( $/ ) {
		make Constant.new( :value-to-fetch( ~$/[0] ) )
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

	method Directive( $/ ) {
		make $/<Directive-Get>.ast
	}

	# The constant chaining of 'make...' seems redundant to me.
	method TOP( $/ ) {
		make $/<Directive>[0].ast
	}
}

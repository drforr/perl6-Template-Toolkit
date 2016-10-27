class Template::Toolkit::Actions {
	has $.stashref;

	use Template::Toolkit::Internal::Clause;
	use Template::Toolkit::Internal::Constant;
	use Template::Toolkit::Internal::Directive::Else;
	use Template::Toolkit::Internal::Directive::Elsif;
	use Template::Toolkit::Internal::Directive::End;
	use Template::Toolkit::Internal::Directive::Foreach;
	use Template::Toolkit::Internal::Directive::If;
	use Template::Toolkit::Internal::Directive::Get;

	# Arguments might have to return to being objects due to stashrefs.
	method Argument( $/ ) {
		make	+$/<Integer> ||
			~$/<String>[0]
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

	method make-hash-closure( $/ ) {
		my $key = ~$/<Function-Name>;
		my @args = $/<Argument>>>.ast;
		sub ( $stash ) {
			if $stash.{$key} and
				$stash.{$key} ~~ Routine and
				@args {
				$stash.{$key}(|@args) // ''
			}
			else {
				$stash.{$key} // ''
			}
		}
	}

	method make-array-closure( $/ ) {
		my $key = +$/<Integer>;
		sub ( $stash ) {
			$stash.[$key] // ''
		}
	}

	method Variable( $/ ) {
		my @closure =
			self.make-hash-closure( $/<Variable-Start> );
		for $/<Variable-Element> {
			my $closure;
			if $_<Variable-Start> {
				$closure =
					self.make-hash-closure(
						$_<Variable-Start>
					)
			}
			elsif $_<Positive-Integer> {
				$closure =
					self.make-array-closure(
						$_<Positive-Integer>
					)
			}
			@closure.append(
				$closure
			)
		}

		make Template::Toolkit::Internal::Directive::Get.new(
			:filter-to-run(
				@closure
			)
		)
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

	# ELSE doesn't introduce a new condition, so it takes no arguments.
	#
	method Directive-Else( $/ ) {
		make Template::Toolkit::Internal::Directive::Else.new
	}

	method Directive-End( $/ ) {
		make Template::Toolkit::Internal::Directive::End.new
	}

	# IF normally won't have values immediately after it.
	# We'll account for those later in testing.
	#
	method Directive-Elsif( $/ ) {
		my $clause = Template::Toolkit::Internal::Clause.new(
			:condition( $/<Expression>.ast )
		);
		make Template::Toolkit::Internal::Directive::Elsif.new(
			:clause( $clause )
		)
	}
	method Directive-Foreach( $/ ) {
		make Template::Toolkit::Internal::Directive::Foreach.new(
			:topic( $/<Variable>.ast ),
			:iterator( $/<Expression>.ast )
		)
	}
	method Directive-If( $/ ) {
		my $clause = Template::Toolkit::Internal::Clause.new(
			:condition( $/<Expression>.ast )
		);
		make Template::Toolkit::Internal::Directive::If.new(
			:clause( $clause )
		)
	}

	method Directive( $/ ) {
		make
		  	$/<Directive-Foreach>.ast
		||	$/<Directive-Get>.ast
		||	$/<Directive-If>.ast
		||	$/<Directive-Else>.ast
		||	$/<Directive-Elsif>.ast
		||	$/<Directive-End>.ast
	}

	# The constant chaining of 'make...' seems redundant to me.
	method TOP( $/ ) {
		make $/<Directive>[0].ast
	}
}

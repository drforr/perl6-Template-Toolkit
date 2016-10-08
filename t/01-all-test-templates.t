use Test;
use Template::Toolkit;

plan 1;

my $tt = Template::Toolkit.new;

sub is-parsed( $test ) {
	ok $tt._parse( $test );
}

sub is-valid( $test, $expected ) {
	ok 1;
}

subtest {
	ok $tt._parse( q:to[__PARSED__] );
args(a b c)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% args(a b c) %]
__TEST__
  ARGS: [ alpha, bravo, charlie ]
 NAMED: {  }
__EXPECTED__
 
	ok $tt._parse( q:to[__PARSED__] );
args(a b c d=e f=g)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% args(a b c d=e f=g) %]
__TEST__
  ARGS: [ alpha, bravo, charlie ]
 NAMED: { d => echo, f => golf }
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
args(a, b, c, d=e, f=g)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% args(a, b, c, d=e, f=g) %]
__TEST__
  ARGS: [ alpha, bravo, charlie ]
 NAMED: { d => echo, f => golf }
__EXPECTED__

# Doesn't break any previous
#	ok $tt._parse( q:to[__PARSED__] );
#args(a, b, c, d=e, f=g,)
#__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% args(a, b, c, d=e, f=g,) %]
__TEST__
  ARGS: [ alpha, bravo, charlie ]
 NAMED: { d => echo, f => golf }
__EXPECTED__

# Doesn't break any previous
#
#	ok $tt._parse( q:to[__PARSED__] );
#args(d=e, a, b, f=g, c)
#__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% args(d=e, a, b, f=g, c) %]
__TEST__
  ARGS: [ alpha, bravo, charlie ]
 NAMED: { d => echo, f => golf }
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
obj.foo(d=e, a, b, f=g, c)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% obj.foo(d=e, a, b, f=g, c) %]
__TEST__
object:
  ARGS: [ alpha, bravo, charlie ]
 NAMED: { d => echo, f => golf }
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
obj.foo(d=e, a, b, f=g, c).split("\n").1
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% obj.foo(d=e, a, b, f=g, c).split("\n").1 %]
__TEST__
  ARGS: [ alpha, bravo, charlie ]
__EXPECTED__

# Doesn't break any previous
# 
#	ok $tt._parse( q:to[__PARSED__] );
#object.nil
#__PARSED__

#`(
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
([% object.nil %])
__TEST__
()
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE assert;
   TRY; object.assert.nil; CATCH; error; END; "\n";
   TRY; object.assert.zip; CATCH; error; END;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% USE assert;
   TRY; object.assert.nil; CATCH; error; END; "\n";
   TRY; object.assert.zip; CATCH; error; END;
%]
__TEST__
assert error - undefined value for nil
assert error - undefined value for zip
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE assert;
   TRY; hash.assert.bar; CATCH; error; END; "\n";
   TRY; hash.assert.bam; CATCH; error; END;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% USE assert;
   TRY; hash.assert.bar; CATCH; error; END; "\n";
   TRY; hash.assert.bam; CATCH; error; END;
%]
__TEST__
assert error - undefined value for bar
assert error - undefined value for bam
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE assert;
   TRY; list.assert.0;     CATCH; error; END; "\n";
   TRY; list.assert.first; CATCH; error; END;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% USE assert;
   TRY; list.assert.0;     CATCH; error; END; "\n";
   TRY; list.assert.first; CATCH; error; END;
%]
__TEST__
assert error - undefined value for 0
assert error - undefined value for first
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% USE assert;
   TRY; list.assert.0;     CATCH; error; END; "\n";
   TRY; list.assert.first; CATCH; error; END;
%]
__TEST__
assert error - undefined value for 0
assert error - undefined value for first
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE assert;
   TRY; assert.nothing; CATCH; error; END;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% USE assert;
   TRY; assert.nothing; CATCH; error; END;
%]
__TEST__
assert error - undefined value for nothing
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE assert;
   TRY; assert.subref; CATCH; error; END;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% USE assert;
   TRY; assert.subref; CATCH; error; END;
%]
__TEST__
assert error - undefined value for subref
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF yes
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
maybe
[% IF yes %]
yes
[% END %]
__TEST__
maybe
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
ELSE
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF yes %]
yes
[% ELSE %]
no 
[% END %]
__TEST__
yes
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF yes %]
yes
[% ELSE %]
no 
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__], True ), 'any case';
IF yes and true
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF yes and true %]
yes
[% ELSE %]
no 
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF yes && true
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF yes && true %]
yes
[% ELSE %]
no 
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF yes && sad || happy
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF yes && sad || happy %]
yes
[% ELSE %]
no 
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__], True ), 'any case';
IF yes AND ten && true and twenty && 30
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF yes AND ten && true and twenty && 30 %]
yes
[% ELSE %]
no
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF ! yes
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF ! yes %]
no
[% ELSE %]
yes
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
UNLESS yes
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% UNLESS yes %]
no
[% ELSE %]
yes
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"yes" UNLESS no
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "yes" UNLESS no %]
__TEST__
yes
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF ! yes %]
no
[% ELSE %]
yes
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF yes || no
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF yes || no %]
yes
[% ELSE %]
no
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF yes || no || true || false
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF yes || no || true || false %]
yes
[% ELSE %]
no
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__], True ), 'any case';
IF yes or no
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF yes or no %]
yes
[% ELSE %]
no
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__], True ), 'any case';
IF not false and not sad
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF not false and not sad %]
yes
[% ELSE %]
no
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF ten == 10
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF ten == 10 %]
yes
[% ELSE %]
no
[% END %]
__TEST__
yes
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF ten == twenty
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
ELSIF ten > twenty
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
ELSIF twenty < ten
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF ten == twenty %]
I canna break the laws of mathematics, Captain.
[% ELSIF ten > twenty %]
Your numerical system is inverted.  Please reboot your Universe.
[% ELSIF twenty < ten %]
Your inverted system is numerical.  Please universe your reboot.
[% ELSE %]
Normality is restored.  Anything you can't cope with is your own problem.
[% END %]
__TEST__
Normality is restored.  Anything you can't cope with is your own problem.
__EXPECTED__

#`( # any-case
	ok $tt._parse( q:to[__PARSED__] );
IF ten >= twenty or false
__PARSED__
)

	ok $tt._parse( q:to[__PARSED__] );
ELSIF twenty <= ten
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF ten >= twenty or false %]
no
[% ELSIF twenty <= ten  %]
nope
[% END %]
nothing
__TEST__
nothing
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF ten > twenty
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
ELSIF ten < twenty
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF ten > twenty %]
no
[% ELSIF ten < twenty  %]
yep
[% END %]
__TEST__
yep
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF ten != 10
__PARSED__
  
	ok $tt._parse( q:to[__PARSED__] );
ELSIF ten == 10
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF ten != 10 %]
no
[% ELSIF ten == 10  %]
yep
[% END %]
__TEST__
yep
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF alpha AND omega
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
count
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF alpha AND omega %]
alpha and omega are true
[% ELSE %]
alpha and/or omega are not true
[% END %]
count: [% count %]
__TEST__
alpha and/or omega are not true
count: 11
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF omega AND alpha %]
omega and alpha are true
[% ELSE %]
omega and/or alpha are not true
[% END %]
count: [% count %]
__TEST__
omega and/or alpha are not true
count: 21
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF alpha OR omega
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF alpha OR omega %]
alpha and/or omega are true
[% ELSE %]
neither alpha nor omega are true
[% END %]
count: [% count %]
__TEST__
alpha and/or omega are true
count: 22
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF omega OR alpha %]
alpha and/or omega are true
[% ELSE %]
neither alpha nor omega are true
[% END %]
count: [% count %]
__TEST__
alpha and/or omega are true
count: 33
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
small = 5
   mid   = 7
   big   = 10
   both  = small + big
   less  = big - mid
   half  = big / small
   left  = big % mid
   mult  = big * small
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
mult + 2 * 2
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
mult * 2 + 2 * 3
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% small = 5
   mid   = 7
   big   = 10
   both  = small + big
   less  = big - mid
   half  = big / small
   left  = big % mid
   mult  = big * small
%]
both: [% both +%]
less: [% less +%]
half: [% half +%]
left: [% left +%]
mult: [% mult +%]
maxi: [% mult + 2 * 2 +%]
mega: [% mult * 2 + 2 * 3 %]
__TEST__
both: 15
less: 3
half: 2
left: 3
mult: 50
maxi: 54
mega: 106
__EXPECTED__

#`( all-case
	ok $tt._parse( q:to[__PARSED__] );
10 mod 4
__PARSED__
)

	ok $tt._parse( q:to[__PARSED__] );
10 MOD 4
__PARSED__

#`( all-case
	ok $tt._parse( q:to[__PARSED__] );
10 div 3
__PARSED__
)

	ok $tt._parse( q:to[__PARSED__] );
10 DIV 3
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% 10 mod 4 +%] [% 10 MOD 4 +%]
[% 10 div 3 %] [% 10 DIV 3 %]
__TEST__
2 2
3 3
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF 'one' lt 'two'
__PARSED__

	# this is for testing the lt operator which isn't enabled by default.
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF 'one' lt 'two' -%]
one is less than two
[% ELSE -%]
ERROR!
[% END -%]
__TEST__
one is less than two
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY; INCLUDE blockdef/block1; CATCH; error; END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY; INCLUDE blockdef/block1; CATCH; error; END %]
__TEST__
file error - blockdef/block1: not found
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE blockdef/block1
__PARSED__

	# use on
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE blockdef/block1 %]
__TEST__
This is block 1, defined in blockdef, a is alpha
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE blockdef/block1 a='amazing'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE blockdef/block1 a='amazing' %]
__TEST__
This is block 1, defined in blockdef, a is amazing
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY; INCLUDE blockdef/none; CATCH; error; END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% TRY; INCLUDE blockdef/none; CATCH; error; END %]
__TEST__
file error - blockdef/none: not found
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE "$dir/blockdef/block1" a='abstract'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE "$dir/blockdef/block1" a='abstract' %]
__TEST__
This is block 1, defined in blockdef, a is abstract
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK one
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE one
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE one/two b='brilliant'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK one -%]
block one
[% BLOCK two -%]
this is block two, b is [% b %]
[% END -%]
two has been defined, let's now include it
[% INCLUDE one/two b='brilliant' -%]
end of block one
[% END -%]
[% INCLUDE one -%]
=
[% INCLUDE one/two b='brazen'-%]
__TEST__
block one
two has been defined, let's now include it
this is block two, b is brilliant
end of block one
=
this is block two, b is brazen
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK block1 %]
This is the original block1
[% END %]
[% INCLUDE block1 %]
[% INCLUDE blockdef %]
[% INCLUDE block1 %]
__TEST__
This is the original block1
start of blockdef
end of blockdef
This is the original block1
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
PROCESS blockdef
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK block1 %]
This is the original block1
[% END %]
[% INCLUDE block1 %]
[% PROCESS blockdef %]
[% INCLUDE block1 %]
__TEST__
This is the original block1
start of blockdef
end of blockdef
This is block 1, defined in blockdef, a is alpha
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE block_a
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE block_a +%]
[% INCLUDE block_b %]
__TEST__
this is block a
this is block b
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE header 
   title = 'A New Beginning'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE header 
   title = 'A New Beginning'
+%]
A long time ago in a galaxy far, far away...
[% PROCESS footer %]
__TEST__
<html><head><title>A New Beginning</title></head><body>
A long time ago in a galaxy far, far away...
</body></html>
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK foo:bar
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK foo:bar %]
blah
[% END %]
[% PROCESS foo:bar %]
__TEST__
blah
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK 'hello html'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK 'hello html' -%]
Hello World!
[% END -%]
[% PROCESS 'hello html' %]
__TEST__
Hello World!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
<[% INCLUDE foo %]>
[% BLOCK foo %][% END %]
__TEST__
<>
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK foo eval_perl=0 tags="star"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK foo eval_perl=0 tags="star" -%]
This is the foo block
[% END -%]
foo: [% INCLUDE foo %]
__TEST__
foo: This is the foo block
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK eval_perl=0 tags="star"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK eval_perl=0 tags="star" -%]
This is an anonymous block
[% END -%]
__TEST__
This is an anonymous block
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
b = INCLUDE foo
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
c = INCLUDE foo a = 'ammended'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK foo %]
This is block foo, a is [% a %]
[% END %]
[% b = INCLUDE foo %]
[% c = INCLUDE foo a = 'ammended' %]
b: <[% b %]>
c: <[% c %]>
__TEST__
b: <This is block foo, a is alpha>
c: <This is block foo, a is ammended>
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
d = BLOCK
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
a = 'charlie'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% d = BLOCK %]
This is the block, a is [% a %]
[% END %]
[% a = 'charlie' %]
a: [% a %]   d: [% d %]
__TEST__
a: charlie   d: This is the block, a is alpha
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
e = IF a == 'alpha'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% e = IF a == 'alpha' %]
a is [% a %]
[% ELSE %]
that was unexpected
[% END %]
e: [% e %]
__TEST__
e: a is alpha
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
a = FOREACH b = [1 2 3]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = FOREACH b = [1 2 3] %]
[% b %],
[%- END %]
a is [% a %]
__TEST__
a is 1,2,3,
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
out = PROCESS userinfo FOREACH user = [ 'tom', 'dick', 'larry' ]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK userinfo %]
name: [% user +%]
[% END %]
[% out = PROCESS userinfo FOREACH user = [ 'tom', 'dick', 'larry' ] %]
Output:
[% out %]
__TEST__
Output:
name: tom
name: dick
name: larry
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
include = a
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
for = b
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% include = a %]
[% for = b %]
i([% include %])
f([% for %])
__TEST__
i(alpha)
f(bravo)
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF a AND b
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF a AND b %]
good
[% ELSE %]
bad
[% END %]
__TEST__
good
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF a and b
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
# 'and', 'or' and 'not' can ALWAYS be expressed in lower case, regardless
# of CASE sensitivity option.
[% IF a and b %]
good
[% ELSE %]
bad
[% END %]
__TEST__
good
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
include = a
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% include = a %]
[% include %]
__TEST__
alpha
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
include foo bar='baz'
__PARSED__

	# USE ANYCASE
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% include foo bar='baz' %]
[% BLOCK foo %]this is foo, bar = [% bar %][% END %]
__TEST__
this is foo, bar = baz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% 10 div 3 %] [% 10 DIV 3 +%]
[% 10 mod 3 %] [% 10 MOD 3 %]
__TEST__
3 3
1 1
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE cgi = CGI('id=abw&name=Andy+Wardley'); global.cgi = cgi
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
global.cgi.param('name')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE cgi = CGI('id=abw&name=Andy+Wardley'); global.cgi = cgi -%]
name: [% global.cgi.param('name') %]
__TEST__
name: Andy Wardley
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
name: [% global.cgi.param('name') %]
__TEST__
name: Andy Wardley
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH key = global.cgi.param.sort
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH key = global.cgi.param.sort -%]
   * [% key %] : [% global.cgi.param(key) %]
[% END %]
__TEST__
   * id : abw
   * name : Andy Wardley
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH key = global.cgi.param().sort
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH key = global.cgi.param().sort -%]
   * [% key %] : [% global.cgi.param(key) %]
[% END %]
__TEST__
   * id : abw
   * name : Andy Wardley
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH x = global.cgi.checkbox_group(
		name     => 'words'
                values   => [ 'eenie', 'meenie', 'minie', 'moe' ]
	        defaults => [ 'eenie', 'meenie' ] )
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH x = global.cgi.checkbox_group(
		name     => 'words'
                values   => [ 'eenie', 'meenie', 'minie', 'moe' ]
	        defaults => [ 'eenie', 'meenie' ] )   -%]
[% x %]
[% END %]
__TEST__
-- process --
[% cgicheck %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE cgi('item=foo&items=one&items=two')
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
cgi.params.item.join(', ')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE cgi('item=foo&items=one&items=two') -%]
item: [% cgi.params.item %]
item: [% cgi.params.item.join(', ') %]
items: [% cgi.params.items.join(', ') %]
__TEST__
item: foo
item: foo
items: one, two
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
a = 10; b = 20
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
begin[% a = 10; b = 20 %]
     [% a %]
     [% b %]
end
__TEST__
begin
     10
     20
end
__EXPECTED__

	# USE tt_pre_all
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
begin[% a = 10; b = 20 %]
     [% a %]
     [% b %]
end
__TEST__
begin1020
end
__EXPECTED__

	# USE tt_pre_all
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
begin[% a = 10; b = 20 %]
     [% a %]
     [% b %]
end
__TEST__
begin1020
end
__EXPECTED__

	# use tt_pre_coll
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
begin[% a = 10; b = 20 %]
     [% a %]
     [% b %]
end
__TEST__
begin 10 20
end
__EXPECTED__

	# use tt_post_none
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
begin[% a = 10; b = 20 %]
     [% a %]
     [% b %]
end
__TEST__
begin
     10
     20
end
__EXPECTED__

	# use tt_post_all
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
begin[% a = 10; b = 20 %]
     [% a %]
     [% b %]
end
__TEST__
begin     10     20end
__EXPECTED__

	# use tt_post_one
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
begin[% a = 10; b = 20 %]
     [% a %]
     [% b %]
end
__TEST__
begin     10     20end
__EXPECTED__

	# use tt_post_coll
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
begin[% a = 10; b = 20 %]     
[% a %]     
[% b %]     
end
__TEST__
begin 10 20 end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE evalperl %]
__TEST__
This file includes a perl block.
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE foo
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
CATCH file
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INCLUDE foo %]
[% CATCH file %]
Error: [% error.type %] - [% error.info %]
[% END %]
__TEST__
This is the foo file, a is 
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
META author => 'abw' version => 3.14
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META author => 'abw' version => 3.14 %]
[% INCLUDE complex %]
__TEST__
This is the header, title: Yet Another Template Test
This is a more complex file which includes some BLOCK definitions
This is the footer, author: abw, version: 3.14
- 3 - 2 - 1 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE baz %]
__TEST__
This is the baz file, a: 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%- # first pass, writes the compiled code to cache -%]
[% INCLUDE divisionbyzero -%]
__TEST__
-- process --
undef error - Illegal division by zero at [% constants.zero %] line 1.
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE foo a = 'any value'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE foo a = 'any value' %]
__TEST__
This is the hacked foo file, a is any value
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META author => 'billg' version => 6.66  %]
[% INCLUDE complex %]
__TEST__
This is the header, title: Yet Another Template Test
This is a more complex file which includes some BLOCK definitions
This is the footer, author: billg, version: 6.66
- 3 - 2 - 1 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META author => 'billg' version => 6.66  %]
[% INCLUDE complex %]
__TEST__
This is the header, title: Yet Another Template Test
This is a more complex file which includes some BLOCK definitions
This is the footer, author: billg, version: 6.66
- 3 - 2 - 1 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%- # second pass, reads the compiled code from cache -%]
[% INCLUDE divisionbyzero -%]
__TEST__
-- process --
undef error - Illegal division by zero at [% constants.zero %] line 1, <DATA> chunk 1.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META author => 'albert' version => 'emc2'  %]
[% INCLUDE complex %]
__TEST__
This is the header, title: Yet Another Template Test
This is a more complex file which includes some BLOCK definitions
This is the footer, author: albert, version: emc2
- 3 - 2 - 1 
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY; INCLUDE complex; CATCH; near_line("$error", 18); END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%# we want to break 'compile' to check that errors get reported -%]
[% CALL bust_it -%]
[% TRY; INCLUDE complex; CATCH; near_line("$error", 18); END %]
__TEST__
file error - parse error - complex line 18ish: unexpected end of input
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INCLUDE foo %]
[% CATCH file %]
Error: [% error.type %] - [% error.info %]
[% END %]
__TEST__
This is the foo file, a is 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META author => 'abw' version => 3.14 %]
[% INCLUDE complex %]
__TEST__
This is the header, title: Yet Another Template Test
This is a more complex file which includes some BLOCK definitions
This is the footer, author: abw, version: 3.14
- 3 - 2 - 1 
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE bar/baz word = 'wibble'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INCLUDE bar/baz word = 'wibble' %]
[% CATCH file %]
Error: [% error.type %] - [% error.info %]
[% END %]
__TEST__
This is file baz
The word is 'wibble'
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE "$root/src/blam"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE "$root/src/blam" %]
__TEST__
This is the blam file
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%- # first pass, writes the compiled code to cache -%]
[% INCLUDE divisionbyzero -%]
__TEST__
-- process --
undef error - Illegal division by zero at [% constants.zero %] line 1.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE foo a = 'any value' %]
__TEST__
This is the newly hacked foo file, a is any value
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META author => 'billg' version => 6.66  %]
[% INCLUDE complex %]
__TEST__
This is the header, title: Yet Another Template Test
This is a more complex file which includes some BLOCK definitions
This is the footer, author: billg, version: 6.66
- 3 - 2 - 1 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE "$root/src/blam" %]
__TEST__
This is the wam-bam file
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%- # second pass, reads the compiled code from cache -%]
[% INCLUDE divisionbyzero -%]
__TEST__
-- process --
undef error - Illegal division by zero at [% constants.zero %] line 1, <DATA> chunk 1.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
hello [% const.author %]
[% "back is $const.col.back" %] and text is [% const.col.text %]
col.user is [% col.user %]
__TEST__
hello Andy 'Da Man' Wardley
back is #ffffff and text is #000000
col.user is red
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
const.col.keys.sort.join(', ')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
# look ma!  I can even call virtual methods on contants!
[% const.col.keys.sort.join(', ') %]
__TEST__
back, text
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
const.col.keys.sort.join(const.joint)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
# and even pass constant arguments to constant virtual methods!
[% const.col.keys.sort.join(const.joint) %]
__TEST__
back, text
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
# my constants can be subs, etc.
zero [% const.counter %]
one [% const.counter %]
__TEST__
zero 0
one 1
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
constants.col.values.sort.reverse.join(constants.joint)
__PARSED__

	# USE tt2
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "$constants.author thinks " %]
[%- constants.col.values.sort.reverse.join(constants.joint) %]
__TEST__
abw thinks orange is the new black
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- use tt3 --
[% "$const.author thinks " -%]
[% const.col.values.sort.reverse.join(const.joint) %]
__TEST__
abw thinks orange is the new black
__EXPECTED__

	# name no const.foo
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
no [% const.foo %]?
__TEST__
no ?
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
const.col.${const.fave}
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
fave [% const.fave %]
col  [% const.col.${const.fave} %]
__TEST__
fave back
col  orange
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"$key\n" FOREACH key = constants.col.keys.sort
__PARSED__

	# use tt2
	# name defer references
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "$key\n" FOREACH key = constants.col.keys.sort %]
__TEST__
back
text
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
const.author = 'Fred Smith'
__PARSED__

	# USE tt3
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
a: [% const.author %]
b: [% const.author = 'Fred Smith' %]
c: [% const.author %]
__TEST__
a: abw
b: 
c: abw
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE userlist = datafile(datafile.0)
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH user = userlist
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE userlist = datafile(datafile.0) %]
Users:
[% FOREACH user = userlist %]
  * $user.id: $user.name
[% END %]
__TEST__
Users:
  * way: Wendy Yardley
  * mop: Marty Proton
  * nellb: Nell Browser
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE userlist = datafile(datafile.1, delim = '|')
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH user = userlist
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE userlist = datafile(datafile.1, delim = '|') %]
Users:
[% FOREACH user = userlist %]
  * $user.id: $user.name <$user.email>
[% END %]
__TEST__
Users:
  * way: Wendy Yardley <way@cre.canon.co.uk>
  * mop: Marty Proton <mop@cre.canon.co.uk>
  * nellb: Nell Browser <nellb@cre.canon.co.uk>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE userlist = datafile(datafile.1, delim = '|') -%]
size: [% userlist.size %]
__TEST__
size: 3
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
date.format(format => '%Y')
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
now('%Y')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date %]
Let's hope the year doesn't roll over in between calls to date.format()
and now()...
Year: [% date.format(format => '%Y') %]
__TEST__
-- process --
Let's hope the year doesn't roll over in between calls to date.format()
and now()...
Year: [% now('%Y') %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE date(time => time)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date(time => time) %]
default: [% date.format %]
__TEST__
-- process --
default: [% defstr %]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date(time => time) %]
[% date.format(format => format.timeday) %]
__TEST__
-- process --
[% daystr %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE date(time => time, format = format.date)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date(time => time, format = format.date) %]
Date: [% date.format %]
__TEST__
-- process --
Date: [% datestr %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE date(format = format.date)
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
date.format(time, format.time)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date(format = format.date) %]
Time: [% date.format(time, format.time) %]
__TEST__
-- process --
Time: [% timestr %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
date.format(time, format = format.time)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date(format = format.date) %]
Time: [% date.format(time, format = format.time) %]
__TEST__
-- process --
Time: [% timestr %]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date(format = format.date) %]
Time: [% date.format(time = time, format = format.time) %]
__TEST__
-- process --
Time: [% timestr %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE english = date(format => '%A', locale => 'en_GB')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE english = date(format => '%A', locale => 'en_GB') %]
[% USE french  = date(format => '%A', locale => 'fr_FR') %]
In English, today's day is: [% english.format +%]
In French, today's day is: [% french.format +%]
__TEST__
-- process --
In English, today's day is: [% time_locale(time, '%A', 'en_GB') +%]
In French, today's day is: [% time_locale(time, '%A', 'fr_FR') +%]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE english = date(format => '%A')
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
USE french  = date()
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
english.format(locale => 'en_GB')
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
french.format(format => '%A', locale => 'fr_FR')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE english = date(format => '%A') %]
[% USE french  = date() %]
In English, today's day is: 
[%- english.format(locale => 'en_GB') +%]
In French, today's day is: 
[%- french.format(format => '%A', locale => 'fr_FR') +%]
__TEST__
-- process --
In English, today's day is: [% time_locale(time, '%A', 'en_GB') +%]
In French, today's day is: [% time_locale(time, '%A', 'fr_FR') +%]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
date.format('4:20:00 13-6-2000', '%H')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date %]
[% date.format('4:20:00 13-6-2000', '%H') %]
__TEST__
04
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date %]
[% date.format('2000-6-13 4:20:00', '%H') %]
__TEST__
04
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
day.format('4:20:00 13-9-2000')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name September 13th 2000 --
[% USE day = date(format => '%A', locale => 'en_GB') %]
[% day.format('4:20:00 13-9-2000') %]
__TEST__
-- process --
[% date_locale('4:20:00 13-9-2000', '%A', 'en_GB') %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
date.format('some stupid date')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% USE date %]
[% date.format('some stupid date') %]
[% CATCH date %]
Bad date: [% e.info %]
[% END %]
__TEST__
Bad date: bad time/date string:  expects 'h:m:s d:m:y'  got: 'some stupid date'
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
date.format(template.modtime, format='%Y')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date %]
[% template.name %] [% date.format(template.modtime, format='%Y') %]
__TEST__
-- process --
input text [% now('%Y') %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE date; calc = date.calc; calc.Monday_of_Week(22, 2001).join('/')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF date_calc -%]
[% USE date; calc = date.calc; calc.Monday_of_Week(22, 2001).join('/') %]
[% ELSE -%]
not testing
[% END -%]
__TEST__
-- process --
[% IF date_calc -%]
2001/5/28
[% ELSE -%]
not testing
[% END -%]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE date;
   date.format('12:59:00 30/09/2001', '%H:%M')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date;
   date.format('12:59:00 30/09/2001', '%H:%M')
-%]
__TEST__
12:59
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date;
   date.format('2001/09/30 12:59:00', '%H:%M')
-%]
__TEST__
12:59
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE date;
   date.format('2001/09/30T12:59:00', '%H:%M')
-%]
__TEST__
12:59
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Hello World
foo: [% foo %]
__TEST__
Hello World
foo: 10
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- use debug --
Hello World
foo: [% foo %]
__TEST__
Hello World
foo: <!-- input text line 2 : [% foo %] -->10
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
DEBUG on
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- use default --
Hello World
foo: [% foo %]
[% DEBUG on -%]
Debugging enabled
foo: [% foo %]
__TEST__
Hello World
foo: 10
Debugging enabled
foo: 10
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
DEBUG off
__PARSED__

	# use debug
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% DEBUG off %]
Hello World
foo: [% foo %]
[% DEBUG on -%]
Debugging enabled
foo: [% foo %]
__TEST__
<!-- input text line 1 : [% DEBUG off %] -->
Hello World
foo: 10
Debugging enabled
foo: <!-- input text line 6 : [% foo %] -->10
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"$baz.ping/$baz.pong"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name ping pong --
foo: [% foo %]
hello [% "$baz.ping/$baz.pong" %] world
[% DEBUG off %]
bar: [% bar %][% DEBUG on %]
__TEST__
foo: <!-- input text line 1 : [% foo %] -->10
hello <!-- input text line 2 : [% "$baz.ping/$baz.pong" %] -->100/200 world
<!-- input text line 3 : [% DEBUG off %] -->
bar: 20
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE foo a=10
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- use debug --
foo: [% foo %]
[% INCLUDE foo a=10 %]
[% DEBUG off -%]
foo: [% foo %]
[% INCLUDE foo a=20 %]
__TEST__
foo: <!-- input text line 1 : [% foo %] -->10
<!-- input text line 2 : [% INCLUDE foo a=10 %] -->This is the foo file, a is 10
<!-- input text line 3 : [% DEBUG off %] -->foo: 10
This is the foo file, a is 20
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
DEBUG format '[ $file line $line ]'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- use default --
[% DEBUG on -%]
[% DEBUG format '[ $file line $line ]' %]
[% foo %]
__TEST__
<!-- input text line 2 : [% DEBUG format '[ $file line $line ]' %] -->
[ input text line 3 ]10
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
DEBUG on + format '[ $file line $line ]'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- use default --
[% DEBUG on + format '[ $file line $line ]' -%]
[% foo %]
__TEST__
[ input text line 2 ]10
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
DEBUG on;
   DEBUG format '$text at line $line of $file';
   DEBUG msg line='3.14' file='this file' text='hello world' 
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% DEBUG on;
   DEBUG format '$text at line $line of $file';
   DEBUG msg line='3.14' file='this file' text='hello world' 
%]
__TEST__
hello world at line 3.14 of this file
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
[%a%]
__TEST__
alpha
alpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
pre [% a %]
pre[% a %]
__TEST__
pre alpha
prealpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %] post
[% a %]post
__TEST__
alpha post
alphapost
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
pre [% a %] post
pre[% a %]post
__TEST__
pre alpha post
prealphapost
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %][%b%][% c %]
__TEST__
alphabravocharlie
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% 
a %][%b
%][%
c
%][%
         d
%]
__TEST__
alphabravocharliedelta
__EXPECTED__

# XXX This won't ever actually get to the parser, since '#' occurs at the start
# XXX of the [%# .. %] tag.
#	ok $tt._parse( q:to[__PARSED__] );
## this is a comment which should
#    be ignored in totality
#__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%# this is a comment which should
    be ignored in totality
%]hello world
__TEST__
hello world
__EXPECTED__

	# XXX Notice that we're stripping the leading space.
	# XXX The upper layer strips leading spaces, so we emulate that
	# XXX behavior here.
	ok $tt._parse( q:to[__PARSED__] );
# this is a one-line comment
   a
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% # this is a one-line comment
   a
%]
__TEST__
alpha
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
# this is a two-line comment
   a =
   # here's the next line
   b
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% # this is a two-line comment
   a =
   # here's the next line
   b
-%]
[% a %]
__TEST__
bravo
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
a = c   # this is a comment on the end of the line
   b = d   # so is this
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = c   # this is a comment on the end of the line
   b = d   # so is this
-%]
a: [% a %]
b: [% b %]
__TEST__
a: charlie
b: delta
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
[% b %]
__TEST__
alpha
bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a -%]
[% b %]
__TEST__
alphabravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a -%]
     [% b %]
__TEST__
alpha     bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
[%- b %]
__TEST__
alphabravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
     [%- b %]
__TEST__
alphabravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
[% a %]
[% b %]
end
__TEST__
start
alpha
bravo
end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
[%- a %]
[% b -%]
end
__TEST__
startalpha
bravoend
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
[%- a -%]
[% b -%]
end
__TEST__
startalphabravoend
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
[%- a %]
[%- b -%]
end
__TEST__
startalphabravoend
__EXPECTED__

	# use pre
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
[% a %]
mid
[% b %]
end
__TEST__
startalpha
midbravo
end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
     [% a %]
mid
	[% b %]
end
__TEST__
startalpha
midbravo
end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
[%+ a %]
mid
[% b %]
end
__TEST__
start
alpha
midbravo
end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
   [%+ a %]
mid
[% b %]
end
__TEST__
start
   alpha
midbravo
end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
   [%- a %]
mid
   [%- b %]
end
__TEST__
startalpha
midbravo
end
__EXPECTED__

	# use post
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
[% a %]
mid
[% b %]
end
__TEST__
start
alphamid
bravoend
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
     [% a %]
mid
	[% b %]        
end
__TEST__
start
     alphamid
	bravoend
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
[% a +%]
mid
[% b %]
end
__TEST__
start
alpha
mid
bravoend
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
[% a +%]   
[% b +%]
end
__TEST__
start
alpha   
bravo
end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start
[% a -%]
mid
[% b -%]
end
__TEST__
start
alphamid
bravoend
__EXPECTED__

	# use trim
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];

[% INCLUDE trimme %]
__TEST__
I am a template element file which will get TRIMmed
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK foo %]

this is block foo

[% END -%]

[% BLOCK bar %]

this is block bar

[% END %]

[% INCLUDE foo %]
[% INCLUDE bar %]
end
__TEST__
this is block foo
this is block bar
end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
<foo>[% PROCESS foo %]</foo>
<bar>[% PROCESS bar %]</bar>
[% BLOCK foo %]

this is block foo

[% END -%]
[% BLOCK bar %]

this is block bar

[% END -%]
end
__TEST__
<foo>this is block foo</foo>
<bar>this is block bar</bar>
end
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
r; r = s; "-"; r
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% r; r = s; "-"; r %].
__TEST__
romeo-sierra.
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
IF a; b; ELSIF c; d; ELSE; s; END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% IF a; b; ELSIF c; d; ELSE; s; END %]
__TEST__
bravo
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY ;
     USE Directory ;
   CATCH ;
     error ;
   END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY ;
     USE Directory ;
   CATCH ;
     error ;
   END
-%]
__TEST__
Directory error - no directory specified
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY ;
     USE Directory('/no/such/place') ;
   CATCH ;
     error.type ; ' error on ' ; error.info.split(':').0 ;
   END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY ;
     USE Directory('/no/such/place') ;
   CATCH ;
     error.type ; ' error on ' ; error.info.split(':').0 ;
   END
-%]
__TEST__
Directory error on /no/such/place
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE d = Directory(dir, nostat=1)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE d = Directory(dir, nostat=1) -%]
[% d.path %]
__TEST__
-- process --
[% dir %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE d = Directory(dir)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE d = Directory(dir) -%]
[% d.path %]
__TEST__
-- process --
[% dir %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE directory(dir)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE directory(dir) -%]
[% directory.path %]
__TEST__
-- process --
[% dir %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH f = d.files
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH f = d.dirs; NEXT IF f.name == 'CVS';
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE d = Directory(dir) -%]
[% FOREACH f = d.files -%]
   - [% f.name %]
[% END -%]
[% FOREACH f = d.dirs; NEXT IF f.name == 'CVS';  -%]
   * [% f.name %]
[% END %]
__TEST__
   - file1
   - file2
   - xyzfile
   * sub_one
   * sub_two
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH f = dir.files
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE dir dir=f FILTER indent(4)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE dir = Directory(dir) -%]
[% INCLUDE dir %]
[% BLOCK dir -%]
* [% dir.name %]
[% FOREACH f = dir.files -%]
    - [% f.name %]
[% END -%]
[% FOREACH f = dir.dirs; NEXT IF f.name == 'CVS';  -%]
[% f.scan -%]
[% INCLUDE dir dir=f FILTER indent(4) -%]
[% END -%]
[% END -%]
__TEST__
* dir
    - file1
    - file2
    - xyzfile
    * sub_one
        - bar
        - foo
    * sub_two
        - waz.html
        - wiz.html
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK dir;
     FOREACH f = dir.list ;
     NEXT IF f.name == 'CVS'; 
       IF f.isdir ;
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
f.scan ;
	 INCLUDE dir dir=f FILTER indent(4) ;
       ELSE
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
END ;
    END ;
   END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE dir = Directory(dir) -%]
* [% dir.path %]
[% INCLUDE dir %]
[% BLOCK dir;
     FOREACH f = dir.list ;
     NEXT IF f.name == 'CVS'; 
       IF f.isdir ; -%]
    * [% f.name %]
[%       f.scan ;
	 INCLUDE dir dir=f FILTER indent(4) ;
       ELSE -%]
    - [% f.name %]
[%     END ;
    END ;
   END -%]
__TEST__
-- process --
* [% dir %]
    - file1
    - file2
    * sub_one
        - bar
        - foo
    * sub_two
        - waz.html
        - wiz.html
    - xyzfile
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE d = Directory(dir, recurse=1)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE d = Directory(dir, recurse=1) -%]
[% FOREACH f = d.files -%]
   - [% f.name %]
[% END -%]
[% FOREACH f = d.dirs; NEXT IF f.name == 'CVS';  -%]
   * [% f.name %]
[% END %]
__TEST__
   - file1
   - file2
   - xyzfile
   * sub_one
   * sub_two
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE dir = Directory(dir, recurse=1, root=cwd)
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK dir;
     FOREACH f = dir.list ;
     NEXT IF f.name == 'CVS'; 
       IF f.isdir ;
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE dir dir=f FILTER indent(4) ;
       ELSE
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE dir = Directory(dir, recurse=1, root=cwd) -%]
* [% dir.path %]
[% INCLUDE dir %]
[% BLOCK dir;
     FOREACH f = dir.list ;
     NEXT IF f.name == 'CVS'; 
       IF f.isdir ; -%]
    * [% f.name %] => [% f.path %] => [% f.abs %]
[%       INCLUDE dir dir=f FILTER indent(4) ;
       ELSE -%]
    - [% f.name %] => [% f.path %] => [% f.abs %]
[%     END ;
    END ;
   END -%]
__TEST__
-- process --
* [% dir %]
    - file1 => [% dir %]/file1 => [% cwd %]/[% dir %]/file1
    - file2 => [% dir %]/file2 => [% cwd %]/[% dir %]/file2
    * sub_one => [% dir %]/sub_one => [% cwd %]/[% dir %]/sub_one
        - bar => [% dir %]/sub_one/bar => [% cwd %]/[% dir %]/sub_one/bar
        - foo => [% dir %]/sub_one/foo => [% cwd %]/[% dir %]/sub_one/foo
    * sub_two => [% dir %]/sub_two => [% cwd %]/[% dir %]/sub_two
        - waz.html => [% dir %]/sub_two/waz.html => [% cwd %]/[% dir %]/sub_two/waz.html
        - wiz.html => [% dir %]/sub_two/wiz.html => [% cwd %]/[% dir %]/sub_two/wiz.html
    - xyzfile => [% dir %]/xyzfile => [% cwd %]/[% dir %]/xyzfile
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE dir = Directory(dir, recurse=1, root=cwd) -%]
* [% dir.path %]
[% INCLUDE dir %]
[% BLOCK dir;
     FOREACH f = dir.list ;
	NEXT IF f.name == 'CVS'; 
	IF f.isdir ; -%]
    * [% f.name %] => [% f.home %]
[%       INCLUDE dir dir=f FILTER indent(4) ;
       ELSE -%]
    - [% f.name %] => [% f.home %]
[%     END ;
    END ;
   END -%]
__TEST__
-- process --
* [% dir %]
    - file1 => [% dot %]
    - file2 => [% dot %]
    * sub_one => [% dot %]
        - bar => [% dot %]/..
        - foo => [% dot %]/..
    * sub_two => [% dot %]
        - waz.html => [% dot %]/..
        - wiz.html => [% dot %]/..
    - xyzfile => [% dot %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
file = dir.file('xyzfile')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE dir = Directory(dir) -%]
[% file = dir.file('xyzfile') -%]
[% file.name %]
__TEST__
xyzfile
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE dir = Directory('.', root=dir)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE dir = Directory('.', root=dir) -%]
[% dir.name %]
[% FOREACH f = dir.files -%]
- [% f.name %]
[% END -%]
__TEST__
.
- file1
- file2
- xyzfile
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK directory; NEXT IF item.name == 'CVS';
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
item.content(view) | indent
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
filelist.print(dir)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW filelist -%]

[% BLOCK file -%]
f [% item.name %] => [% item.path %]
[% END -%]

[% BLOCK directory; NEXT IF item.name == 'CVS';  -%]
d [% item.name %] => [% item.path %]
[% item.content(view) | indent -%]
[% END -%]

[% END -%]
[% USE dir = Directory(dir, recurse=1) -%]
[% filelist.print(dir) %]
__TEST__
-- process --
d dir => [% dir %]
    f file1 => [% dir %]/file1
    f file2 => [% dir %]/file2
    d sub_one => [% dir %]/sub_one
        f bar => [% dir %]/sub_one/bar
        f foo => [% dir %]/sub_one/foo
    d sub_two => [% dir %]/sub_two
        f waz.html => [% dir %]/sub_two/waz.html
        f wiz.html => [% dir %]/sub_two/wiz.html
    f xyzfile => [% dir %]/xyzfile
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
META
   author = 'Tom Smith'
   version = 1.23 
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
# test metadata
[% META
   author = 'Tom Smith'
   version = 1.23 
-%]
version [% template.version %] by [% template.author %]
__TEST__
version 1.23 by Tom Smith
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK foo -%]
   This is block foo
[% INCLUDE bar -%]
   This is the end of block foo
[% END -%]
[% BLOCK bar -%]
   This is block bar
[% END -%]
[% PROCESS foo %]
__TEST__
   This is block foo
   This is block bar
   This is the end of block foo
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
META title = 'My Template Title'
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
template.title or title
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META title = 'My Template Title' -%]
[% BLOCK header -%]
title: [% template.title or title %]
[% END -%]
[% INCLUDE header %]
__TEST__
title: My Template Title
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK header -%]
HEADER
component title: [% component.name %]
 template title: [% template.name %]
[% END -%]
component title: [% component.name %]
 template title: [% template.name %]
[% PROCESS header %]
__TEST__
component title: input text
 template title: input text
HEADER
component title: header
 template title: input text
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE header title = 'A New Title'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META title = 'My Template Title' -%]
[% BLOCK header -%]
title: [% title or template.title  %]
[% END -%]
[% INCLUDE header title = 'A New Title' %]
[% INCLUDE header %]
__TEST__
title: A New Title

title: My Template Title
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE $mydoc %]
__TEST__
some output
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE one;
   INCLUDE two;
   INCLUDE three;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE one;
   INCLUDE two;
   INCLUDE three;
%]
__TEST__
one, three
two, three
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Dumper -%]
Dumper
__TEST__
Dumper
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
Dumper.dump({ foo = 'bar' }, 'hello' )
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Dumper -%]
[% Dumper.dump({ foo = 'bar' }, 'hello' ) -%]
__TEST__
$VAR1 = {
          'foo' => 'bar'
        };
$VAR2 = 'hello';
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Dumper -%]
[% Dumper.dump(params) -%]
__TEST__
$VAR1 = {
          'baz' => 'boo'
        };
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
Dumper.dump_html(params)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Dumper -%]
[% Dumper.dump_html(params) -%]
__TEST__
$VAR1 = {<br>
          'baz' =&gt; 'boo'<br>
        };<br>
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE dumper(indent=1, pad='> ', varname="frank")
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE dumper(indent=1, pad='> ', varname="frank") -%]
[% dumper.dump(params) -%]
__TEST__
> $frank1 = {
>   'baz' => 'boo'
> };
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE dumper(Pad='>> ', Varname="bob")
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE dumper(Pad='>> ', Varname="bob") -%]
[% dumper.dump(params) -%]
__TEST__
>> $bob1 = {
>>   'baz' => 'boo'
>> };
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
META 
   author  = 'Andy Wardley'
   title   = 'Test Template $foo #6'
   version = 1.23
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
PERL
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
CATCH
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
RAWPERL
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META 
   author  = 'Andy Wardley'
   title   = 'Test Template $foo #6'
   version = 1.23
%]
[% TRY %]
[% PERL %]
    my $output = "author: [% template.author %]\n";
    $stash->set('a', 'The cat sat on the mat');
    $output .= "more perl generated output\n";
    print $output;
[% END %]
[% CATCH %]
Not allowed: [% error +%]
[% END %]
a: [% a +%]
a: $a
[% TRY %]
[% RAWPERL %]
$output .= "The cat sat on the mouse mat\n";
$stash->set('b', 'The cat sat where?');
[% END %]
[% CATCH %]
Still not allowed: [% error +%]
[% END %]
b: [% b +%]
b: $b
__TEST__
Not allowed: perl error - EVAL_PERL not set
a: alpha
a: alpha
Still not allowed: perl error - EVAL_PERL not set
b: bravo
b: bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
nothing
[% PERL %]
We don't care about correct syntax within PERL blocks if EVAL_PERL isn't set.
They're simply ignored.
[% END %]
[% CATCH %]
ERROR: [% error.type %]: [% error.info %]
[% END %]
__TEST__
nothing
ERROR: perl: EVAL_PERL not set
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
some stuff
[% TRY %]
[% INCLUDE badrawperl %]
[% CATCH %]
ERROR: [[% error.type %]] [% error.info %]
[% END %]
__TEST__
some stuff
This is some text
ERROR: [perl] EVAL_PERL not set
__EXPECTED__

	# use do_perl
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
some stuff
[% TRY %]
[% INCLUDE badrawperl %]
[% CATCH +%]
ERROR: [[% error.type %]]
[% END %]
__TEST__
some stuff
This is some text
more stuff goes here
ERROR: [undef]
__EXPECTED__

	# use do_perl
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META author = 'Andy Wardley' %]
[% PERL %]
    my $output = "author: [% template.author %]\n";
    $stash->set('a', 'The cat sat on the mat');
    $output .= "more perl generated output\n";
    print $output;
[% END %]
__TEST__
author: Andy Wardley
more perl generated output
__EXPECTED__

	# use do_perl
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META 
   author  = 'Andy Wardley'
   title   = 'Test Template $foo #6'
   version = 3.14
%]
[% PERL %]
    my $output = "author: [% template.author %]\n";
    $stash->set('a', 'The cat sat on the mat');
    $output .= "more perl generated output\n";
    print $output;
[% END %]
a: [% a +%]
a: $a
[% RAWPERL %]
$output .= "The cat sat on the mouse mat\n";
$stash->set('b', 'The cat sat where?');
[% END %]
b: [% b +%]
b: $b
__TEST__
author: Andy Wardley
more perl generated output
a: The cat sat on the mat
a: The cat sat on the mat
The cat sat on the mouse mat
b: The cat sat where?
b: The cat sat where?
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK foo %]This is block foo[% END %]
[% PERL %]
print $context->include('foo');
print PERLOUT "\nbar\n";
[% END %]
The end
__TEST__
This is block foo
bar
The end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
   [%- PERL %] die "nothing to live for\n" [% END %]
[% CATCH %]
   error: [% error %]
[% END %]
__TEST__
   error: undef error - nothing to live for
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% foo.bar %]
__TEST__
Place to purchase drinks
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% constant.pi %]
__TEST__
3.14
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
place = 'World'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% place = 'World' -%]
Hello [% place %]
[% a = a + 1 -%]
file: [% file %]
line: [% line %]
warn: [% warn %]
__TEST__
-- process --
Hello World
file: input text
line: 3
warn: Argument "" isn't numeric in addition (+)
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
file.chunk(-16).last
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE warning -%]
file: [% file.chunk(-16).last %]
line: [% line %]
warn: [% warn %]
__TEST__
-- process --
Hello
World
file: test/lib/warning
line: 2
warn: Argument "" isn't numeric in addition (+)
__EXPECTED__

	# use not
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE warning -%]
file: [% file.chunk(-16).last %]
line: [% line %]
warn: [% warn %]
__TEST__
Hello
World
file: (eval)
line: 10
warn: Argument "" isn't numeric in addition (+)
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY; 
     INCLUDE chomp; 
   CATCH; 
     error; 
   END 
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY; 
     INCLUDE chomp; 
   CATCH; 
     error; 
   END 
%]
__TEST__
file error - parse error - chomp line 6: unexpected token (END)
  [% END %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE f = File('/foo/bar/baz.html', nostat=1)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE f = File('/foo/bar/baz.html', nostat=1) -%]
p: [% f.path %]
r: [% f.root %]
n: [% f.name %]
d: [% f.dir %]
e: [% f.ext %]
h: [% f.home %]
a: [% f.abs %]
__TEST__
p: /foo/bar/baz.html
r: 
n: baz.html
d: /foo/bar
e: html
h: ../..
a: /foo/bar/baz.html
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE f = File('foo/bar/baz.html', nostat=1) -%]
p: [% f.path %]
r: [% f.root %]
n: [% f.name %]
d: [% f.dir %]
e: [% f.ext %]
h: [% f.home %]
a: [% f.abs %]
__TEST__
p: foo/bar/baz.html
r: 
n: baz.html
d: foo/bar
e: html
h: ../..
a: foo/bar/baz.html
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE f = File('baz.html', nostat=1)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE f = File('baz.html', nostat=1) -%]
p: [% f.path %]
r: [% f.root %]
n: [% f.name %]
d: [% f.dir %]
e: [% f.ext %]
h: [% f.home %]
a: [% f.abs %]
__TEST__
p: baz.html
r: 
n: baz.html
d: 
e: html
h: 
a: baz.html
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE f = File('bar/baz.html', root='/foo', nostat=1)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE f = File('bar/baz.html', root='/foo', nostat=1) -%]
p: [% f.path %]
r: [% f.root %]
n: [% f.name %]
d: [% f.dir %]
e: [% f.ext %]
h: [% f.home %]
a: [% f.abs %]
__TEST__
p: bar/baz.html
r: /foo
n: baz.html
d: bar
e: html
h: ..
a: /foo/bar/baz.html
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
f.rel('wiz/waz.html')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% USE f = File('bar/baz.html', root='/foo', nostat=1) -%]
p: [% f.path %]
h: [% f.home %]
rel: [% f.rel('wiz/waz.html') %]
__TEST__
p: bar/baz.html
h: ..
rel: ../wiz/waz.html
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE baz = File('foo/bar/baz.html', root='/tmp/tt2', nostat=1)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% USE baz = File('foo/bar/baz.html', root='/tmp/tt2', nostat=1) -%]
[% USE waz = File('wiz/woz/waz.html', root='/tmp/tt2', nostat=1) -%]
[% baz.rel(waz) %]
__TEST__
../../wiz/woz/waz.html
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE f = File('foo/bar/baz.html', nostat=1) -%]
[[% f.atime %]]
__TEST__
[]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE f = File(file)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE f = File(file) -%]
[% f.path %]
[% f.name %]
__TEST__
-- process --
[% dir %]/src/foo
foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE f = File(file) -%]
[% f.path %]
[% f.mtime %]
__TEST__
-- process --
[% dir %]/src/foo
[% mtime %]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE file(file) -%]
[% file.path %]
[% file.mtime %]
__TEST__
-- process --
[% dir %]/src/foo
[% mtime %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE f = File('')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY -%]
[% USE f = File('') -%]
n: [% f.name %]
[% CATCH -%]
Drat, there was a [% error.type %] error.
[% END %]
__TEST__
Drat, there was a File error.
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FILTER nonfilt
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% FILTER nonfilt %]
blah blah blah
[% END %]
[% CATCH %]
BZZZT: [% error.type %]: [% error.info %]
[% END %]
__TEST__
BZZZT: filter: invalid FILTER entry for 'nonfilt' (not a CODE ref)
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% FILTER badfact %]
blah blah blah
[% END %]
[% CATCH %]
BZZZT: [% error.type %]: [% error.info %]
[% END %]
__TEST__
BZZZT: filter: invalid FILTER for 'badfact' (not a CODE ref)
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% FILTER badfilt %]
blah blah blah
[% END %]
[% CATCH %]
BZZZT: [% error.type %]: [% error.info %]
[% END %]
__TEST__
BZZZT: filter: invalid FILTER entry for 'badfilt' (not a CODE ref)
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY;
     "foo" | barfilt;
   CATCH;
     "$error.type: $error.info";
   END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY;
     "foo" | barfilt;
   CATCH;
     "$error.type: $error.info";
   END
%]
__TEST__
filter: barfed
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY;
     "foo" | barfilt(1);
   CATCH;
     "$error.type: $error.info";
   END
%]
__TEST__
dead: deceased
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY;
     "foo" | barfilt(2);
   CATCH;
     "$error.type: $error.info";
   END
%]
__TEST__
filter: keeled over
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY;
     "foo" | barfilt(3);
   CATCH;
     "$error.type: $error.info";
   END
%]
__TEST__
unwell: sick as a parrot
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER html %]
This is some html text
All the <tags> should be escaped & protected
[% END %]
__TEST__
This is some html text
All the &lt;tags&gt; should be escaped &amp; protected
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% text = "The <cat> sat on the <mat>" %]
[% FILTER html %]
   text: $text
[% END %]
__TEST__
   text: The &lt;cat&gt; sat on the &lt;mat&gt;
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% text = "The <cat> sat on the <mat>" %]
[% text FILTER html %]
__TEST__
The &lt;cat&gt; sat on the &lt;mat&gt;
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER html %]
"It isn't what I expected", he replied.
[% END %]
__TEST__
&quot;It isn't what I expected&quot;, he replied.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER xml %]
"It isn't what I expected", he replied.
[% END %]
__TEST__
&quot;It isn&apos;t what I expected&quot;, he replied.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER format %]
Hello World!
[% END %]
__TEST__
Hello World!
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FILTER comment = format('<!-- %s -->')
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
"Goodbye, cruel World" FILTER comment
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
# test aliasing of a filter
[% FILTER comment = format('<!-- %s -->') %]
Hello World!
[% END +%]
[% "Goodbye, cruel World" FILTER comment %]
__TEST__
<!-- Hello World! -->
<!-- Goodbye, cruel World -->
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER format %]
Hello World!
[% END %]
__TEST__
Hello World!
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"Foo" FILTER test1 = format('+++ %-4s +++')
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH item = [ 'Bar' 'Baz' 'Duz' 'Doze' ]
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
item FILTER test1
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "Foo" FILTER test1 = format('+++ %-4s +++') +%]
[% FOREACH item = [ 'Bar' 'Baz' 'Duz' 'Doze' ] %]
  [% item FILTER test1 +%]
[% END %]
[% "Wiz" FILTER test1 = format("*** %-4s ***") +%]
[% "Waz" FILTER test1 +%]
__TEST__
+++ Foo  +++
  +++ Bar  +++
  +++ Baz  +++
  +++ Duz  +++
  +++ Doze +++
*** Wiz  ***
*** Waz  ***
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER microjive %]
The "Halloween Document", leaked to Eric Raymond from an insider
at Microsoft, illustrated Microsoft's strategy of "Embrace,
Extend, Extinguish"
[% END %]
__TEST__
The "Halloween Document", leaked to Eric Raymond from an insider
at The 'Soft, illustrated The 'Soft's strategy of "Embrace,
Extend, Extinguish"
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER microsloth %]
The "Halloween Document", leaked to Eric Raymond from an insider
at Microsoft, illustrated Microsoft's strategy of "Embrace,
Extend, Extinguish"
[% END %]
__TEST__
The "Halloween Document", leaked to Eric Raymond from an insider
at Microsloth, illustrated Microsloth's strategy of "Embrace,
Extend, Extinguish"
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FILTER censor('bottom' 'nipple')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER censor('bottom' 'nipple') %]
At the bottom of the hill, he had to pinch the
nipple to reduce the oil flow.
[% END %]
__TEST__
At the [** CENSORED **] of the hill, he had to pinch the
[** CENSORED **] to reduce the oil flow.
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FILTER bold = format('<b>%s</b>')
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
'This is both' FILTER bold FILTER italic
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER bold = format('<b>%s</b>') %]
This is bold
[% END +%]
[% FILTER italic = format('<i>%s</i>') %]
This is italic
[% END +%]
[% 'This is both' FILTER bold FILTER italic %]
__TEST__
<b>This is bold</b>
<i>This is italic</i>
<i><b>This is both</b></i>
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"foo" FILTER format("<< %s >>") FILTER format("=%s=")
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "foo" FILTER format("<< %s >>") FILTER format("=%s=") %]
__TEST__
=<< foo >>=
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
blocktext = BLOCK
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
global.blocktext = blocktext; blocktext
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% blocktext = BLOCK %]
The cat sat on the mat

Mary had a little Lamb



You shall have a fishy on a little dishy, when the boat comes in.  What 
if I can't wait until then?  I'm hungry!
[% END -%]
[% global.blocktext = blocktext; blocktext %]
__TEST__
The cat sat on the mat

Mary had a little Lamb



You shall have a fishy on a little dishy, when the boat comes in.  What 
if I can't wait until then?  I'm hungry!
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
global.blocktext FILTER html_para
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.blocktext FILTER html_para %]
__TEST__
<p>
The cat sat on the mat
</p>

<p>
Mary had a little Lamb
</p>

<p>
You shall have a fishy on a little dishy, when the boat comes in.  What 
if I can't wait until then?  I'm hungry!
</p>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.blocktext FILTER html_break %]
__TEST__
The cat sat on the mat
<br />
<br />
Mary had a little Lamb
<br />
<br />
You shall have a fishy on a little dishy, when the boat comes in.  What 
if I can't wait until then?  I'm hungry!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.blocktext FILTER html_para_break %]
__TEST__
The cat sat on the mat
<br />
<br />
Mary had a little Lamb
<br />
<br />
You shall have a fishy on a little dishy, when the boat comes in.  What 
if I can't wait until then?  I'm hungry!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.blocktext FILTER html_line_break %]
__TEST__
The cat sat on the mat<br />
<br />
Mary had a little Lamb<br />
<br />
<br />
<br />
You shall have a fishy on a little dishy, when the boat comes in.  What <br />
if I can't wait until then?  I'm hungry!<br />
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
global.blocktext FILTER truncate(10)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.blocktext FILTER truncate(10) %]
__TEST__
The cat...
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.blocktext FILTER truncate %]
__TEST__
The cat sat on the mat

Mary ...
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
'Hello World' | truncate(2)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% 'Hello World' | truncate(2) +%]
[% 'Hello World' | truncate(8) +%]
[% 'Hello World' | truncate(10) +%]
[% 'Hello World' | truncate(11) +%]
[% 'Hello World' | truncate(20) +%]
__TEST__
..
Hello...
Hello W...
Hello World
Hello World
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"foo..." FILTER repeat(5)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "foo..." FILTER repeat(5) %]
__TEST__
foo...foo...foo...foo...foo...
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER truncate(21) %]
I have much to say on this matter that has previously been said
on more than one occassion.
[% END %]
__TEST__
I have much to say...
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER truncate(25) %]
Nothing much to say
[% END %]
__TEST__
Nothing much to say
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER repeat(3) %]
Am I repeating myself?
[% END %]
__TEST__
Am I repeating myself?
Am I repeating myself?
Am I repeating myself?
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
text FILTER remove(' ')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% text FILTER remove(' ') +%]
[% text FILTER remove('\s+') +%]
[% text FILTER remove('cat') +%]
[% text FILTER remove('at') +%]
[% text FILTER remove('at', 'splat') +%]
__TEST__
Thecatsatonthemat
Thecatsatonthemat
The  sat on the mat
The c s on the m
The c s on the m
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
text FILTER replace(' ', '_')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% text FILTER replace(' ', '_') +%]
[% text FILTER replace('sat', 'shat') +%]
[% text FILTER replace('at', 'plat') +%]
__TEST__
The_cat_sat_on_the_mat
The cat shat on the mat
The cplat splat on the mplat
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% text = 'The <=> operator' %]
[% text|html %]
__TEST__
The &lt;=&gt; operator
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
text | html | replace('blah', 'rhubarb')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% text = 'The <=> operator, blah, blah' %]
[% text | html | replace('blah', 'rhubarb') %]
__TEST__
The &lt;=&gt; operator, rhubarb, rhubarb
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
| truncate(25)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% | truncate(25) %]
The cat sat on the mat, and wondered to itself,
"How might I be able to climb up onto the shelf?",
For up there I am sure I'll see,
A tasty fishy snack for me.
[% END %]
__TEST__
The cat sat on the mat...
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER upper %]
The cat sat on the mat
[% END %]
__TEST__
THE CAT SAT ON THE MAT
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER lower %]
The cat sat on the mat
[% END %]
__TEST__
the cat sat on the mat
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
'arse' | stderr
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% 'arse' | stderr %]
stderr: [% stderr %]
__TEST__
stderr: arse
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
percent = '%'
   left    = "[$percent"
   right   = "$percent]"
   dir     = "$left a $right blah blah $left b $right"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% percent = '%'
   left    = "[$percent"
   right   = "$percent]"
   dir     = "$left a $right blah blah $left b $right"
%]
[% dir +%]
FILTER [[% dir | eval %]]
FILTER [[% dir | evaltt %]]
__TEST__
[% a %] blah blah [% b %]
FILTER [alpha blah blah bravo]
FILTER [alpha blah blah bravo]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
dir = "[\% FOREACH a = { 1 2 3 } %\]a: [\% a %\]\n[\% END %\]"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% TRY %]
[% dir = "[\% FOREACH a = { 1 2 3 } %\]a: [\% a %\]\n[\% END %\]" %]
[% dir | eval %]
[% CATCH %]
error: [[% error.type %]] [[% error.info %]]
[% END %]
__TEST__
error: [file] [parse error - input text line 1: unexpected token (1)
  [% FOREACH a = { 1 2 3 } %]]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY;
    '$x = 10; $b = 20; $x + $b' | evalperl;
   CATCH;
     "$error.type: $error.info";
   END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
nothing
[% TRY;
    '$x = 10; $b = 20; $x + $b' | evalperl;
   CATCH;
     "$error.type: $error.info";
   END
+%]
happening
__TEST__
nothing
perl: EVAL_PERL is not set
happening
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY -%]
before
[% FILTER redirect('xyz') %]
blah blah blah
here is the news
[% a %]
[% END %]
after
[% CATCH %]
ERROR [% error.type %]: [% error.info %]
[% END %]
__TEST__
before
ERROR redirect: OUTPUT_PATH is not set
__EXPECTED__

	# use evalperl
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER evalperl %]
   $a = 10;
   $b = 20;
   $stash->{ foo } = $a + $b;
   $stash->{ bar } = $context->config->{ BARVAL };
   "all done"
[% END +%]
foo: [% foo +%]
bar: [% bar %]
__TEST__
all done
foo: 30
bar: some random value
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY -%]
before
[% FILTER file(outfile) -%]
blah blah blah
here is the news
[% a %]
[% END -%]
after
[% CATCH %]
ERROR [% error.type %]: [% error.info %]
[% END %]
__TEST__
before
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PERL %]
# static filter subroutine
$Template::Filters::FILTERS->{ bar } = sub {
    my $text = shift; 
    $text =~ s/^/bar: /gm;
    return $text;
};
[% END -%]
[% FILTER bar -%]
The cat sat on the mat
The dog sat on the log
[% END %]
__TEST__
bar: The cat sat on the mat
bar: The dog sat on the log
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PERL %]
# dynamic filter factory
$Template::Filters::FILTERS->{ baz } = [
    sub {
	my $context = shift;
	my $word = shift || 'baz';
	return sub {
	    my $text = shift; 
            $text =~ s/^/$word: /gm;
	    return $text;
	};
    }, 1 ];
[% END -%]
[% FILTER baz -%]
The cat sat on the mat
The dog sat on the log
[% END %]
[% FILTER baz('wiz') -%]
The cat sat on the mat
The dog sat on the log
[% END %]
__TEST__
baz: The cat sat on the mat
baz: The dog sat on the log

wiz: The cat sat on the mat
wiz: The dog sat on the log
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FILTER $merlyn
__PARSED__

	# use evalperl
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PERL %]
$stash->set('merlyn', bless \&merlyn1, 'ttfilter');
sub merlyn1 {
    my $text = shift || '<no text>';
    $text =~ s/stone/henge/g;
    return $text;
}
[% END -%]
[% FILTER $merlyn -%]
Let him who is without sin cast the first stone.
[% END %]
__TEST__
Let him who is without sin cast the first henge.
__EXPECTED__

	# use evalperl
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PERL %]
$stash->set('merlyn', sub { \&merlyn2 });
sub merlyn2 {
    my $text = shift || '<no text>';
    $text =~ s/stone/henge/g;
    return $text;
}
[% END -%]
[% FILTER $merlyn -%]
Let him who is without sin cast the first stone.
[% END %]
__TEST__
Let him who is without sin cast the first henge.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myfilter = 'html' -%]
[% FILTER $myfilter -%]
<html>
[% END %]
__TEST__
&lt;html&gt;
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER $despace -%]
blah blah blah
[%- END %]
__TEST__
blah_blah_blah
__EXPECTED__

	# use evalperl
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PERL %]
$context->filter(\&newfilt, undef, 'myfilter');
sub newfilt {
    my $text = shift;
    $text =~ s/\s+/=/g;
    return $text;
}
[% END -%]
[% FILTER myfilter -%]
This is a test
[%- END %]
__TEST__
This=is=a=test
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PERL %]
$context->define_filter('xfilter', \&xfilter);
sub xfilter {
    my $text = shift;
    $text =~ s/\s+/X/g;
    return $text;
}
[% END -%]
[% FILTER xfilter -%]
blah blah blah
[%- END %]
__TEST__
blahXblahXblah
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER another(3) -%]
foo bar baz
[% END %]
__TEST__
foo bar baz
foo bar baz
foo bar baz
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
'$stash->{ a } = 25' FILTER evalperl
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% '$stash->{ a } = 25' FILTER evalperl %]
[% a %]
__TEST__
25
25
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
'$stash->{ a } = 25' FILTER perl
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% '$stash->{ a } = 25' FILTER perl %]
[% a %]
__TEST__
25
25
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER indent -%]
The cat sat
on the mat
[% END %]
__TEST__
    The cat sat
    on the mat
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER indent(2) -%]
The cat sat
on the mat
[% END %]
__TEST__
  The cat sat
  on the mat
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER indent('>> ') -%]
The cat sat
on the mat
[% END %]
__TEST__
>> The cat sat
>> on the mat
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
text = 'The cat sat on the mat';
   text | indent('> ') | indent('+')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% text = 'The cat sat on the mat';
   text | indent('> ') | indent('+') %]
__TEST__
+> The cat sat on the mat
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
<<[% FILTER trim %]
   
          
The cat sat
on the
mat


[% END %]>>
__TEST__
<<The cat sat
on the
mat>>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
<<[% FILTER collapse %]
   
          
The    cat     sat
on    the
mat


[% END %]>>
__TEST__
<<The cat sat on the mat>>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER format('++%s++') %]Hello World[% END %]
[% FILTER format %]Hello World[% END %]
__TEST__
++Hello World++
Hello World
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"my file.html" FILTER uri
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "my file.html" FILTER uri %]
__TEST__
my%20file.html
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"my<file & your>file.html" FILTER uri
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "my<file & your>file.html" FILTER uri %]
__TEST__
my%3Cfile%20%26%20your%3Efile.html
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "foo@bar" FILTER uri %]
__TEST__
foo%40bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "foo@bar" FILTER url %]
__TEST__
foo@bar
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"my<file & your>file.html" | uri | html
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "my<file & your>file.html" | uri | html %]
__TEST__
my%3Cfile%20%26%20your%3Efile.html
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% widetext | uri %]
__TEST__
wide%3A%E6%97%A5%E6%9C%AC%E8%AA%9E
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
'foobar' | ucfirst
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% 'foobar' | ucfirst %]
__TEST__
Foobar
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
'FOOBAR' | lcfirst
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% 'FOOBAR' | lcfirst %]
__TEST__
fOOBAR
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"foo(bar)" | uri
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "foo(bar)" | uri %]
__TEST__
foo(bar)
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"foo(bar)" | url
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "foo(bar)" | url %]
__TEST__
foo(bar)
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
use_rfc3986;
   "foo(bar)" | url;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% use_rfc3986; "foo(bar)" | url;
%]
__TEST__
foo%28bar%29
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "foo(bar)" | uri %]
__TEST__
foo%28bar%29
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
use_rfc2732;
   "foo(bar)" | url;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% use_rfc2732;
   "foo(bar)" | url;
%]
__TEST__
foo(bar)
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "foo(bar)" | uri %]
__TEST__
foo(bar)
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH a = [ 1, 2, 3 ]
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH foo.bar
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH a = [ 1, 2, 3 ] %]
   [% a +%]
[% END %]

[% FOREACH foo.bar %]
   [% a %]
[% END %]
__TEST__
   1
   2
   3
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH count = [ 'five' 'four' 'three' 'two' 'one' ]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Commence countdown...
[% FOREACH count = [ 'five' 'four' 'three' 'two' 'one' ] %]
  [% count +%]
[% END %]
Fire!
__TEST__
Commence countdown...
  five
  four
  three
  two
  one
Fire!
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOR count = [ 1 2 3 ]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOR count = [ 1 2 3 ] %]${count}..[% END %]
__TEST__
1..2..3..
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
people = [ c, bloke, o, 'frank' ]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
people:
[% bloke = r %]
[% people = [ c, bloke, o, 'frank' ] %]
[% FOREACH person = people %]
  [ [% person %] ]
[% END %]
__TEST__
people:
  [ charlie ]
  [ romeo ]
  [ oscar ]
  [ frank ]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH name = setb %]
[% name %],
[% END %]
__TEST__
charlie,
lima,
oscar,
uncle,
delta,
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH name = r %]
[% name %], $name, wherefore art thou, $name?
[% END %]
__TEST__
romeo, romeo, wherefore art thou, romeo?
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% user = 'fred' %]
[% FOREACH user = users %]
   $user.name ([% user.id %])
[% END %]
   [% user.name %]
__TEST__
   Andy Wardley (abw)
   Simon Matthews (sam)
   Simon Matthews
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
name = 'Joe Random Hacker' id = 'jrh'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% name = 'Joe Random Hacker' id = 'jrh' %]
[% FOREACH users %]
   $name ([% id %])
[% END %]
   $name ($id)
__TEST__
   Andy Wardley (abw)
   Simon Matthews (sam)
   Joe Random Hacker (jrh)
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH i = [1..4]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH i = [1..4] %]
[% i +%]
[% END %]
__TEST__
1
2
3
4
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
first = 4 
   last  = 8
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH i = [first..last]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% first = 4 
   last  = 8
%]
[% FOREACH i = [first..last] %]
[% i +%]
[% END %]
__TEST__
4
5
6
7
8
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
list.${n}
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list = [ 'one' 'two' 'three' 'four' ] %]
[% list.0 %] [% list.3 %]

[% FOREACH n = [0..3] %]
[% list.${n} %], 
[%- END %]
__TEST__
one four
one, two, three, four, 
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"$i, " FOREACH i = [-2..2]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "$i, " FOREACH i = [-2..2] %]
__TEST__
-2, -1, 0, 1, 2, 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH i = item -%]
    - [% i %]
[% END %]
__TEST__
    - foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH i = items -%]
    - [% i +%]
[% END %]
__TEST__
    - foo
    - bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH item = [ a b c d ] %]
$item
[% END %]
__TEST__
alpha
bravo
charlie
delta
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
items = [ d C a c b ]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% items = [ d C a c b ] %]
[% FOREACH item = items.sort %]
$item
[% END %]
__TEST__
alpha
bravo
CHARLIE
charlie
delta
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH item = items.sort.reverse
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% items = [ d a c b ] %]
[% FOREACH item = items.sort.reverse %]
$item
[% END %]
__TEST__
delta
charlie
bravo
alpha
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
userlist = [ b c d a C 'Andy' 'tom' 'dick' 'harry' ]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% userlist = [ b c d a C 'Andy' 'tom' 'dick' 'harry' ] %]
[% FOREACH u = userlist.sort %]
$u
[% END %]
__TEST__
alpha
Andy
bravo
charlie
CHARLIE
delta
dick
harry
tom
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
ulist = [ b c d a 'Andy' ]
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
USE f = format("[- %-7s -]\n")
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
f(item) FOREACH item = ulist.sort
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% ulist = [ b c d a 'Andy' ] %]
[% USE f = format("[- %-7s -]\n") %]
[% f(item) FOREACH item = ulist.sort %]
__TEST__
[- alpha   -]
[- Andy    -]
[- bravo   -]
[- charlie -]
[- delta   -]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"List of $loop.size items:\\n" IF loop.first
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH item = [ a b c d ] %]
[% "List of $loop.size items:\\n" IF loop.first %]
  #[% loop.number %]/[% loop.size %]: [% item +%]
[% "That's all folks\\n" IF loop.last %]
[% END %]
__TEST__
List of 4 items:
  #1/4: alpha
  #2/4: bravo
  #3/4: charlie
  #4/4: delta
That's all folks
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"List of $loop.size items:\n----------------\n" IF loop.first
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% items = [ d b c a ] %]
[% FOREACH item = items.sort %]
[% "List of $loop.size items:\n----------------\n" IF loop.first %]
 * [% item +%]
[% "----------------\n" IF loop.last  %]
[% END %]
__TEST__
List of 4 items:
----------------
 * alpha
 * bravo
 * charlie
 * delta
----------------
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
i = inc(i)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list = [ a b c d ] %]
[% i = 1 %]
[% FOREACH item = list %]
 #[% i %]/[% list.size %]: [% item +%]
[% i = inc(i) %]
[% END %]
__TEST__
 #1/4: alpha
 #2/4: bravo
 #3/4: charlie
 #4/4: delta
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH a = ['foo', 'bar', 'baz']
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH a = ['foo', 'bar', 'baz'] %]
* [% loop.index %] [% a +%]
[% FOREACH b = ['wiz', 'woz', 'waz'] %]
  - [% loop.index %] [% b +%]
[% END %]
[% END %]
__TEST__
* 0 foo
  - 0 wiz
  - 1 woz
  - 2 waz
* 1 bar
  - 0 wiz
  - 1 woz
  - 2 waz
* 2 baz
  - 0 wiz
  - 1 woz
  - 2 waz
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
id    = 12345
   name  = 'Original'
   user1 = { id => 'tom', name => 'Thomas'   }
   user2 = { id => 'reg', name => 'Reginald' }
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH [ user1 ]
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% id    = 12345
   name  = 'Original'
   user1 = { id => 'tom', name => 'Thomas'   }
   user2 = { id => 'reg', name => 'Reginald' }
%]
[% FOREACH [ user1 ] %]
  id: [% id +%]
  name: [% name +%]
[% FOREACH [ user2 ] %]
  - id: [% id +%]
  - name: [% name +%]
[% END %]
[% END %]
id: [% id +%]
name: [% name +%]
__TEST__
  id: tom
  name: Thomas
  - id: reg
  - name: Reginald
id: 12345
name: Original
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
them = [ people.1 people.2 ]
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
"$p.id($p.code): $p.name\n"
       FOREACH p = them.sort('id')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% them = [ people.1 people.2 ] %]
[% "$p.id($p.code): $p.name\n"
       FOREACH p = them.sort('id') %]
__TEST__
aaz(zaz): Azbaz Azbaz Zazbazzer
bcd(dec): Binary Coded Decimal
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "$p.id($p.code): $p.name\n"
       FOREACH p = people.sort('code') %]
__TEST__
abw(abw): Andy Wardley
bcd(dec): Binary Coded Decimal
aaz(zaz): Azbaz Azbaz Zazbazzer
efg(zzz): Extra Fine Grass
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"$p.id($p.code): $p.name\n"
       FOREACH p = people.sort('code').reverse
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "$p.id($p.code): $p.name\n"
       FOREACH p = people.sort('code').reverse %]
__TEST__
efg(zzz): Extra Fine Grass
aaz(zaz): Azbaz Azbaz Zazbazzer
bcd(dec): Binary Coded Decimal
abw(abw): Andy Wardley
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"$p.id($p.code): $p.name\n"
       FOREACH p = people.sort('code')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "$p.id($p.code): $p.name\n"
       FOREACH p = people.sort('code') %]
__TEST__
abw(abw): Andy Wardley
bcd(dec): Binary Coded Decimal
aaz(zaz): Azbaz Azbaz Zazbazzer
efg(zzz): Extra Fine Grass
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Section List:
[% FOREACH item = sections %]
  [% item.key %] - [% item.value +%]
[% END %]
__TEST__
Section List:
  four - Section Four
  one - Section One
  three - Section Three
  two - Section Two
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
NEXT IF a == 5
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH a = [ 2..6 ] %]
before [% a %]
[% NEXT IF a == 5 +%]
after [% a +%]
[% END %]
__TEST__
before 2
after 2
before 3
after 3
before 4
after 4
before 5before 6
after 6
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
count = 1; WHILE (count < 10)
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
count = count + 1
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
NEXT IF count < 5
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% count = 1; WHILE (count < 10) %]
[% count = count + 1 %]
[% NEXT IF count < 5 %]
count: [% count +%]
[% END %]
__TEST__
count: 5
count: 6
count: 7
count: 8
count: 9
count: 10
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOR count = [ 1 2 3 ] %]${count}..[% END %]
__TEST__
1..2..3..
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH count = [ 1 2 3 ] %]${count}..[% END %]
__TEST__
1..2..3..
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOR [ 1 2 3 ] %]<blip>..[% END %]
__TEST__
<blip>..<blip>..<blip>..
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH [ 1 2 3 ] %]<blip>..[% END %]
__TEST__
<blip>..<blip>..<blip>..
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% FOREACH outer = nested -%]
outer start
[% FOREACH inner = outer -%]
inner [% inner +%]
[% "last inner\n" IF loop.last -%]
[% END %]
[% "last outer\n" IF loop.last -%]
[% END %]
__TEST__
outer start
inner a
inner b
inner c
last inner
outer start
inner x
inner y
inner z
last inner
last outer
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH n = [ 1 2 3 4 5 ] -%]
[% LAST IF loop.last -%]
[% n %], 
[%- END %]
__TEST__
1, 2, 3, 4, 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH n = [ 1 2 3 4 5 ] -%]
[% BREAK IF loop.last -%]
[% n %], 
[%- END %]
__TEST__
1, 2, 3, 4, 
__EXPECTED__

	# use debug
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH a = [ 1, 2, 3 ] -%]
* [% a %]
[% END -%]
__TEST__
* 1
* 2
* 3
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH i = [1 .. 10];
        SWITCH i;
        CASE 5;
            NEXT;
        CASE 8;
            LAST;
        END;
        "$i\n";
    END;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%
    FOREACH i = [1 .. 10];
        SWITCH i;
        CASE 5;
            NEXT;
        CASE 8;
            LAST;
        END;
        "$i\n";
    END;
-%]
__TEST__
1
2
3
4
6
7
__EXPECTED__

	# XXX Elided leading sapce
	ok $tt._parse( q:to[__PARSED__] );
FOREACH i = [1 .. 10];
        IF 1;
            IF i == 5; NEXT; END;
            IF i == 8; LAST; END;
        END;
        "$i\n";
    END;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%
    FOREACH i = [1 .. 10];
        IF 1;
            IF i == 5; NEXT; END;
            IF i == 8; LAST; END;
        END;
        "$i\n";
    END;
-%]
__TEST__
1
2
3
4
6
7
__EXPECTED__

	# XXX Eliding leading space
	ok $tt._parse( q:to[__PARSED__] );
FOREACH i = [1 .. 4];
        FOREACH j = [1 .. 4];
            k = 1;
            SWITCH j;
                CASE 2;
                FOREACH k IN [ 1 .. 2 ]; LAST; END;
            CASE 3;
                NEXT IF j == 3;
            END;
            "$i,$j,$k\n";
        END;
    END;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%
    FOREACH i = [1 .. 4];
        FOREACH j = [1 .. 4];
            k = 1;
            SWITCH j;
                CASE 2;
                FOREACH k IN [ 1 .. 2 ]; LAST; END;
            CASE 3;
                NEXT IF j == 3;
            END;
            "$i,$j,$k\n";
        END;
    END;
-%]
__TEST__
1,1,1
1,2,1
1,4,1
2,1,1
2,2,1
2,4,1
3,1,1
3,2,1
3,4,1
4,1,1
4,2,1
4,4,1
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
LAST FOREACH k = [ 1 .. 4];
    "$k\n";
    # Should finish loop with k = 4.  Instead this is an infinite loop!!
    #NEXT FOREACH k = [ 1 .. 4];
    #"$k\n";
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%
    LAST FOREACH k = [ 1 .. 4];
    "$k\n";
    # Should finish loop with k = 4.  Instead this is an infinite loop!!
    #NEXT FOREACH k = [ 1 .. 4];
    #"$k\n";
-%]
__TEST__
1
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH prime IN [2, 3, 5, 7, 11, 13];
     "$prime\n";
    END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH prime IN [2, 3, 5, 7, 11, 13];
     "$prime\n";
    END
-%]
__TEST__
2
3
5
7
11
13
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH i IN [ 1..6 ];
        "${i}: ";
        j = 0;
        WHILE j < i;
            j = j + 1;
            NEXT IF j > 3;
            "${j} ";
        END;
        "\n";
    END;
__PARSED__

	# name FOR/WHILE/NEXT
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  FOREACH i IN [ 1..6 ];
        "${i}: ";
        j = 0;
        WHILE j < i;
            j = j + 1;
            NEXT IF j > 3;
            "${j} ";
        END;
        "\n";
    END;
%]
__TEST__
1: 1 
2: 1 2 
3: 1 2 3 
4: 1 2 3 
5: 1 2 3 
6: 1 2 3 
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE format %]
[% bold = format('<b>%s</b>') %]
[% ital = format('<i>%s</i>') %]
[% bold('heading') +%]
[% ital('author')  +%]
${ ital('affil.') }
[% bold('footing')  +%]
$bold
__TEST__
<b>heading</b>
<i>author</i>
<i>affil.</i>
<b>footing</b>
<b></b>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE format('<li> %s') %]
[% FOREACH item = [ a b c d ] %]
[% format(item) +%]
[% END %]
__TEST__
<li> alpha
<li> bravo
<li> charlie
<li> delta
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE bold = format("<b>%s</b>") %]
[% USE ital = format("<i>%s</i>") %]
[% bold('This is bold')   +%]
[% ital('This is italic') +%]
__TEST__
<b>This is bold</b>
<i>This is italic</i>
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE padleft  = format('%-*s')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE padleft  = format('%-*s') %]
[% USE padright = format('%*s')  %]
[% padleft(10, a) %]-[% padright(10, b) %]
__TEST__
alpha     -     bravo
__EXPECTED__

	# name HTML plugin
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE HTML -%]
OK
__TEST__
OK
__EXPECTED__

	# name HTML filter
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER html -%]
< &amp; >
[%- END %]
__TEST__
&lt; &amp;amp; &gt;
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY; 
        text = "Léon Brocard" | html_entity;

        IF text == "L&eacute;on Brocard";
            'passed';
        ELSIF text == "L&#233;on Brocard";
            'passed';
        ELSE;
            "failed: $text";
        END;
    CATCH;
        error;
    END;
__PARSED__

	# name html filter
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  TRY; 
        text = "Léon Brocard" | html_entity;

        IF text == "L&eacute;on Brocard";
            'passed';
        ELSIF text == "L&#233;on Brocard";
            'passed';
        ELSE;
            "failed: $text";
        END;
    CATCH;
        error;
    END;
%]
__TEST__
-- process --
[%  IF entities -%]
passed
[%- ELSE -%]
html_entity error - cannot locate Apache::Util or HTML::Entities
[%- END %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE html; html.url('my file.html')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE html; html.url('my file.html') -%]
__TEST__
my%20file.html
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
HTML.escape("if (a < b && c > d) ...")
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name escape --
[% USE HTML -%]
[% HTML.escape("if (a < b && c > d) ...") %]
__TEST__
if (a &lt; b &amp;&amp; c &gt; d) ...
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
HTML.element(table => { border => 1, cellpadding => 2 })
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name sorted --
[% USE HTML(sorted=1) -%]
[% HTML.element(table => { border => 1, cellpadding => 2 }) %]
__TEST__
<table border="1" cellpadding="2">
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
HTML.attributes(border => 1, cellpadding => 2).split.sort.join
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name attributes --
[% USE HTML -%]
[% HTML.attributes(border => 1, cellpadding => 2).split.sort.join %]
__TEST__
border="1" cellpadding="2"
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE Image(file.logo)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Image(file.logo) -%]
file: [% Image.file %]
size: [% Image.size.join(', ') %]
width: [% Image.width %]
height: [% Image.height %]
__TEST__
-- process --
file: [% file.logo %]
size: 110, 60
width: 110
height: 60
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE image( name = file.power)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE image( name = file.power) -%]
name: [% image.name %]
file: [% image.file %]
width: [% image.width %]
height: [% image.height %]
size: [% image.size.join(', ') %]
__TEST__
-- process --
name: [% file.power %]
file: [% file.power %]
width: 78
height: 47
size: 78, 47
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE image file.logo -%]
attr: [% image.attr %]
__TEST__
attr: width="110" height="60"
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE image file.logo -%]
tag: [% image.tag %]
tag: [% image.tag(class="myimage", alt="image") %]
__TEST__
-- process --
tag: <img src="[% file.logo %]" width="110" height="60" alt="" />
tag: <img src="[% file.logo %]" width="110" height="60" alt="image" class="myimage" />


# test "root"
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE image( root=dir name=file.lname )
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE image( root=dir name=file.lname ) -%]
[% image.tag %]
__TEST__
<img src="[% file.lname %]" width="110" height="60" alt="" />
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE image( file= file.logo  name = "other.jpg" alt="myfile")
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE image( file= file.logo  name = "other.jpg" alt="myfile") -%]
[% image.tag %]
__TEST__
<img src="other.jpg" width="110" height="60" alt="myfile" />
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
[% PROCESS incblock -%]
[% b %]
[% INCLUDE first_block %]
__TEST__
alpha
bravo
this is my first block, a is set to 'alpha'
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE first_block %]
__TEST__
this is my first block, a is set to 'alpha'
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE first_block a = 'abstract'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE first_block a = 'abstract' %]
[% a %]
__TEST__
this is my first block, a is set to 'abstract'
alpha
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE 'first_block' a = t
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE 'first_block' a = t %]
[% a %]
__TEST__
this is my first block, a is set to 'tango'
alpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE 'second_block' %]
__TEST__
this is my second block, a is initially set to 'alpha' and 
then set to 'sierra'  b is bravo  m is 98
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE second_block a = r, b = c.f.g, m = 97
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE second_block a = r, b = c.f.g, m = 97 %]
[% a %]
__TEST__
this is my second block, a is initially set to 'romeo' and 
then set to 'sierra'  b is golf  m is 97
alpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
FOO: [% INCLUDE foo +%]
FOO: [% INCLUDE foo a = b -%]
__TEST__
FOO: This is the foo file, a is alpha
FOO: This is the foo file, a is bravo
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE $c.f.g  g = c.f.h
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
DEFAULT g = "a new $c.f.g"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
GOLF: [% INCLUDE $c.f.g %]
GOLF: [% INCLUDE $c.f.g  g = c.f.h %]
[% DEFAULT g = "a new $c.f.g" -%]
[% g %]
__TEST__
GOLF: This is the golf file, g is golf
GOLF: This is the golf file, g is hotel
a new golf
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
BAZ: [% INCLUDE bar/baz %]
BAZ: [% INCLUDE bar/baz word='wizzle' %]
BAZ: [% INCLUDE "bar/baz" %]
__TEST__
BAZ: This is file baz
The word is 'qux'
BAZ: This is file baz
The word is 'wizzle'
BAZ: This is file baz
The word is 'qux'
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
BAZ: [% INCLUDE bar/baz.txt %]
BAZ: [% INCLUDE bar/baz.txt time = 'nigh' %]
__TEST__
BAZ: This is file baz
The word is 'qux'
The time is now
BAZ: This is file baz
The word is 'qux'
The time is nigh
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK bamboozle -%]
This is bamboozle
[%- END -%]
Block defined...
[% blockname = 'bamboozle' -%]
[% INCLUDE $blockname %]
End
__TEST__
Block defined...
This is bamboozle
End
__EXPECTED__

	# use reset
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
[% PROCESS incblock -%]
[% INCLUDE first_block %]
[% INCLUDE second_block %]
[% b %]
__TEST__
alpha
this is my first block, a is set to 'alpha'
this is my second block, a is initially set to 'alpha' and 
then set to 'sierra'  b is bravo  m is 98
bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INCLUDE first_block %]
[% CATCH file %]
ERROR: [% error.info %]
[% END %]
__TEST__
ERROR: first_block: not found
__EXPECTED__

	# use default
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% metaout %]
__TEST__
-- process --
TITLE: The cat sat on the mat
metadata last modified [% metamod %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
PROCESS recurse counter = 1
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% TRY %]
[% PROCESS recurse counter = 1 %]
[% CATCH file -%]
[% error.info %]
[% END %]
__TEST__
recursion count: 1
recursion into 'my file'
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE nosuchfile %]
__TEST__
This is the default file
__EXPECTED__

	# use reset
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% TRY %]
[% PROCESS recurse counter = 1 %]
[% CATCH file %]
[% error.info %]
[% END %]
__TEST__
recursion count: 1
recursion count: 2
recursion count: 3
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY;
   INCLUDE nosuchfile;
   CATCH;
   "ERROR: $error";
   END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY;
   INCLUDE nosuchfile;
   CATCH;
   "ERROR: $error";
   END
%]
__TEST__
ERROR: file error - nosuchfile: not found
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK src:foo; "This is foo!"; END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE src:foo %]
[% BLOCK src:foo; "This is foo!"; END %]
__TEST__
This is foo!
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
a = ''; b = ''; d = ''; e = 0
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE foo name = a or b or 'c'
               item = d or e or 'f'
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK foo; "name: $name  item: $item\n"; END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = ''; b = ''; d = ''; e = 0 %]
[% INCLUDE foo name = a or b or 'c'
               item = d or e or 'f' -%]
[% BLOCK foo; "name: $name  item: $item\n"; END %]
__TEST__
name: c  item: f
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
style = 'light'; your_title="Hello World"
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE foo 
         title = my_title or your_title or default_title
         bgcol = (style == 'dark' ? '#000000' : '#ffffff')
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK foo; "title: $title\nbgcol: $bgcol\n"; END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% style = 'light'; your_title="Hello World" -%]
[% INCLUDE foo 
         title = my_title or your_title or default_title
         bgcol = (style == 'dark' ? '#000000' : '#ffffff') %]
[% BLOCK foo; "title: $title\nbgcol: $bgcol\n"; END %]
__TEST__
title: Hello World
bgcol: #ffffff
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
myhash = {
    name  = 'Tom'
    item  = 'teacup'
   }
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE myblock
    name = 'Fred'
    item = 'fish'
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
PROCESS myblock
     import={ name = 'Tim', item = 'teapot' }
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myhash = {
    name  = 'Tom'
    item  = 'teacup'
   }
-%]
[% INCLUDE myblock
    name = 'Fred'
    item = 'fish'
%]
[% INCLUDE myblock
     import=myhash
%]
import([% import %])
[% PROCESS myblock
     import={ name = 'Tim', item = 'teapot' }
%]
import([% import %])
[% BLOCK myblock %][% name %] has a [% item %][% END %]
__TEST__
Fred has a fish
Tom has a teacup
import()
Tim has a teapot
import()
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% items = [ 'foo' 'bar' 'baz' 'qux' ] %]
[% FOREACH i = items %]
   * [% i +%]
[% END %]
__TEST__
   * foo
   * bar
   * baz
   * qux
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% items = [ 'foo' 'bar' 'baz' 'qux' ] %]
[% FOREACH i = items %]
   #[% loop.index %]/[% loop.max %] [% i +%]
[% END %]
__TEST__
   #0/3 foo
   #1/3 bar
   #2/3 baz
   #3/3 qux
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% items = [ 'foo' 'bar' 'baz' 'qux' ] %]
[% FOREACH i = items %]
   #[% loop.count %]/[% loop.size %] [% i +%]
[% END %]
__TEST__
   #1/4 foo
   #2/4 bar
   #3/4 baz
   #4/4 qux
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
# test that 'number' is supported as an alias to 'count', for backwards
# compatability
[% items = [ 'foo' 'bar' 'baz' 'qux' ] %]
[% FOREACH i = items %]
   #[% loop.number %]/[% loop.size %] [% i +%]
[% END %]
__TEST__
   #1/4 foo
   #2/4 bar
   #3/4 baz
   #4/4 qux
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE iterator(data) %]
[% FOREACH i = iterator %]
[% IF iterator.first %]
List of items:
[% END %]
   * [% i +%]
[% IF iterator.last %]
End of list
[% END %]
[% END %]
__TEST__
List of items:
   * foo
   * bar
   * baz
   * qux
   * wiz
   * woz
   * waz
End of list
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH i = [ 'foo' 'bar' 'baz' 'qux' ] %]
[% "$loop.prev<-" IF loop.prev -%][[% i -%]][% "->$loop.next" IF loop.next +%]
[% END %]
__TEST__
[foo]->bar
foo<-[bar]->baz
bar<-[baz]->qux
baz<-[qux]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name test even/odd/parity --
[% FOREACH item IN [1..10] -%]
* [% loop.count %] [% loop.odd %] [% loop.even %] [% loop.parity +%]
[% END -%]
__TEST__
* 1 1 0 odd
* 2 0 1 even
* 3 1 0 odd
* 4 0 1 even
* 5 1 0 odd
* 6 0 1 even
* 7 1 0 odd
* 8 0 1 even
* 9 1 0 odd
* 10 0 1 even
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
a = holler('first'); trace
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = holler('first'); trace %]
__TEST__
first created
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% trace %]
__TEST__
first created
first destroyed
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
clear; b = [ ]; b.0 = holler('list'); trace
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% clear; b = [ ]; b.0 = holler('list'); trace %]
__TEST__
list created
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% trace %]
__TEST__
list created
list destroyed
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK shout; a = holler('second'); END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK shout; a = holler('second'); END -%]
[% clear; PROCESS shout; trace %]
__TEST__
second created
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK shout; a = holler('third'); END -%]
[% clear; INCLUDE shout; trace %]
__TEST__
third created
third destroyed
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
MACRO shout BLOCK; a = holler('fourth'); END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% MACRO shout BLOCK; a = holler('fourth'); END -%]
[% clear; shout; trace %]
__TEST__
fourth created
fourth destroyed
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
clear; USE holler('holler plugin'); trace
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% clear; USE holler('holler plugin'); trace %]
__TEST__
holler plugin created
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK shout; USE holler('process plugin'); END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK shout; USE holler('process plugin'); END -%]
[% clear; PROCESS shout; holler.trace %]
__TEST__
TRACE ==process plugin created
==
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK shout; USE holler('include plugin'); END -%]
[% clear; INCLUDE shout; trace %]
__TEST__
include plugin created
include plugin destroyed
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
MACRO shout BLOCK; USE holler('macro plugin'); END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% MACRO shout BLOCK; USE holler('macro plugin'); END -%]
[% clear; shout; trace %]
__TEST__
macro plugin created
macro plugin destroyed
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
MACRO shout BLOCK; 
	USE holler('macro plugin'); 
	holler.trace;
    END 
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  MACRO shout BLOCK; 
	USE holler('macro plugin'); 
	holler.trace;
    END 
-%]
[% clear; shout; trace %]
__TEST__
TRACE ==macro plugin created
==macro plugin created
macro plugin destroyed
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
clear; PROCESS leak1; trace
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% clear; PROCESS leak1; trace %]
__TEST__
<leak1>
</leak1>
Hello created
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% clear; INCLUDE leak1; trace %]
__TEST__
<leak1>
</leak1>
Hello created
Hello destroyed
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% clear; PROCESS leak2; trace %]
__TEST__
<leak2>
</leak2>
Goodbye created
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% clear; INCLUDE leak2; trace %]
__TEST__
<leak2>
</leak2>
Goodbye created
Goodbye destroyed
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
MACRO leak BLOCK;
	PROCESS leak1 + leak2;
        USE holler('macro plugin');
    END
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
IF v56;
	clear; leak; trace;
    ELSE;
       "Perl version < 5.6.0 or > 5.7.0, skipping this test";
    END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  MACRO leak BLOCK; 
	PROCESS leak1 + leak2;
        USE holler('macro plugin'); 
    END 
-%]
[% IF v56;
	clear; leak; trace;
    ELSE;
       "Perl version < 5.6.0 or > 5.7.0, skipping this test";
    END
-%]
__TEST__
-- process --
[% IF v56 -%]
<leak1>
</leak1>
<leak2>
</leak2>
Hello created
Goodbye created
macro plugin created
Hello destroyed
Goodbye destroyed
macro plugin destroyed
[% ELSE -%]
Perl version < 5.6.0 or > 5.7.0, skipping this test
[% END -%]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PERL %]
    Holler->clear();
    my $h = Holler->new('perl');
    $stash->set( h => $h );
[% END -%]
[% trace %]
__TEST__
perl created
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK x; PERL %]
    Holler->clear();
    my $h = Holler->new('perl');
    $stash->set( h => $h );
[% END; END -%]
[% x; trace %]
__TEST__
perl created
perl destroyed
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
MACRO y PERL
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
y; trace
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% MACRO y PERL %]
    Holler->clear();
    my $h = Holler->new('perl macro');
    $stash->set( h => $h );
[% END -%]
[% y; trace %]
__TEST__
perl macro created
perl macro destroyed
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
data.0
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data.0 %] and [% data.1 %]
__TEST__
romeo and juliet
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data.first %] - [% data.last %]
__TEST__
romeo - zulu
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data.size %] [% data.max %]
__TEST__
8 7
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data.join(', ') %]
__TEST__
romeo, juliet, sierra, tango, yankee, echo, foxtrot, zulu
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
data.reverse.join(', ')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data.reverse.join(', ') %]
__TEST__
zulu, foxtrot, echo, yankee, tango, sierra, juliet, romeo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data.sort.reverse.join(' - ') %]
__TEST__
zulu - yankee - tango - sierra - romeo - juliet - foxtrot - echo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH item = wxyz.sort('id') -%]
* [% item.name %]
[% END %]
__TEST__
* Warlock
* Xeexeez
* Yinyang
* Zebedee
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
FOREACH item = wxyz.sort('rank')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH item = wxyz.sort('rank') -%]
* [% item.name %]
[% END %]
__TEST__
* Zebedee
* Xeexeez
* Yinyang
* Warlock
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH n = [0..6] -%]
[% days.$n +%]
[% END -%]
__TEST__
Mon
Tue
Wed
Thu
Fri
Sat
Sun
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data = [ 'one', 'two', data.first ] -%]
[% data.join(', ') %]
__TEST__
one, two, romeo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data = [ 90, 8, 70, 6, 1, 11, 10, 2, 5, 50, 52 ] -%]
 sort: [% data.sort.join(', ') %]
nsort: [% data.nsort.join(', ') %]
__TEST__
 sort: 1, 10, 11, 2, 5, 50, 52, 6, 70, 8, 90
nsort: 1, 2, 5, 6, 8, 10, 11, 50, 52, 70, 90
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
ilist.push("<a href=\"$i.url\">$i.name</a>") FOREACH i = inst
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% ilist = [] -%]
[% ilist.push("<a href=\"$i.url\">$i.name</a>") FOREACH i = inst -%]
[% ilist.join(",\n") -%]
[% global.ilist = ilist -%]
__TEST__
<a href="/roses.html">piano</a>,
<a href="/blow.html">flute</a>,
<a href="/tulips.html">organ</a>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% global.ilist.pop %]
__TEST__
<a href="/tulips.html">organ</a>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% global.ilist.shift %]
__TEST__
<a href="/roses.html">piano</a>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% global.ilist.unshift('another') -%]
[% global.ilist.join(', ') %]
__TEST__
another, <a href="/blow.html">flute</a>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% nest.0.0 %].[% nest.0.1 %][% nest.0.2 +%]
[% nest.1.shift %].[% nest.1.0.join('') %]
__TEST__
3.14
2.718
__EXPECTED__

	# XXX Elide the leading space
	ok $tt._parse( q:to[__PARSED__] );
# define some initial data
   people   => [ 
     { id => 'tom',   name => 'Tom'     },
     { id => 'dick',  name => 'Richard' },
     { id => 'larry', name => 'Larry'   },
   ]
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
folk.push("<a href=\\"${person.id}.html\\">$person.name</a>")
       FOREACH person = people.sort('name')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% # define some initial data
   people   => [ 
     { id => 'tom',   name => 'Tom'     },
     { id => 'dick',  name => 'Richard' },
     { id => 'larry', name => 'Larry'   },
   ]
-%]
[% folk = [] -%]
[% folk.push("<a href=\"${person.id}.html\">$person.name</a>")
       FOREACH person = people.sort('name') -%]
[% folk.join(",\n") -%]
__TEST__
<a href="larry.html">Larry</a>,
<a href="dick.html">Richard</a>,
<a href="tom.html">Tom</a>
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
data.grep('r').join(', ')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data.grep('r').join(', ') %]
__TEST__
romeo, sierra, foxtrot
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data.grep('^r').join(', ') %]
__TEST__
romeo
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
MACRO foo INCLUDE foo
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% MACRO foo INCLUDE foo -%]
foo: [% foo %]
foo(b): [% foo(a = b) %]
__TEST__
foo: This is the foo file, a is alpha
foo(b): This is the foo file, a is bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
foo: [% foo %].
__TEST__
foo: .
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% MACRO foo(a) INCLUDE foo -%]
foo: [% foo %]
foo(c): [% foo(c) %]
__TEST__
foo: This is the foo file, a is
foo(c): This is the foo file, a is charlie
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE mypage a = 'New Alpha'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK mypage %]
Header
[% content %]
Footer
[% END %]

[%- MACRO content BLOCK -%]
This is a macro which encapsulates a template block.
a: [% a -%]
[% END -%]

begin
[% INCLUDE mypage %]
mid
[% INCLUDE mypage a = 'New Alpha' %]
end
__TEST__
begin
Header
This is a macro which encapsulates a template block.
a: alpha
Footer
mid
Header
This is a macro which encapsulates a template block.
a: New Alpha
Footer
end
__EXPECTED__

	# XXX Notice we're eliding the leading space
	ok $tt._parse( q:to[__PARSED__] );
# now we can call the main table template, and alias our macro to 'rows' 
   INCLUDE table 
     rows = user_summary
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK table %]
<table>
[% rows %]
</table>
[% END -%]

[% # define some dummy data
   udata = [
      { id => 'foo', name => 'Fubar' },
      { id => 'bar', name => 'Babar' }
   ] 
-%]

[% # define a macro to print each row of user data
   MACRO user_summary INCLUDE user_row FOREACH user = udata 
%]

[% # here's the block for each row
   BLOCK user_row %]
<tr>
  <td>[% user.id %]</td>
  <td>[% user.name %]</td>
</tr>
[% END -%]

[% # now we can call the main table template, and alias our macro to 'rows' 
   INCLUDE table 
     rows = user_summary
%]
__TEST__
<table>
<tr>
  <td>foo</td>
  <td>Fubar</td>
</tr><tr>
  <td>bar</td>
  <td>Babar</td>
</tr>
</table>
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
MACRO two BLOCK; title="2[$title]"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% MACRO one BLOCK -%]
one: [% title %]
[% END -%]
[% saveone = one %]
[% MACRO two BLOCK; title="2[$title]" -%]
two: [% title %] -> [% saveone %]
[% END -%]
[% two(title="The Title") %]
__TEST__
two: 2[The Title] -> one:
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
two(title="The Title")
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% MACRO one BLOCK -%]
one: [% title %]
[% END -%]
[% saveone = \one %]
[% MACRO two BLOCK; title="2[$title]" -%]
two: [% title %] -> [% saveone %]
[% END -%]
[% two(title="The Title") %]
__TEST__
two: 2[The Title] -> one: 2[The Title]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
MACRO number(n) GET n.chunk(-3).join(',')
__PARSED__

	# name number macro
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% MACRO number(n) GET n.chunk(-3).join(',') -%]
[% number(1234567) %]
__TEST__
1,234,567
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
MACRO triple(n) PERL
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name perl macro --
[% MACRO triple(n) PERL %]
    my $n = $stash->get('n');
    print $n * 3;
[% END -%]
[% triple(10) %]
__TEST__
30
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE Math; Math.sqrt(9)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Math; Math.sqrt(9) %]
__TEST__
3
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Math; Math.abs(-1) %]
__TEST__
1
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE Math; Math.atan2(42, 42).substr(0,17)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Math; Math.atan2(42, 42).substr(0,17) %]
__TEST__
0.785398163397448
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Math; Math.cos(2).substr(0,18) %]
__TEST__
-0.416146836547142
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Math; Math.exp(6).substr(0,16) %]
__TEST__
403.428793492735
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Math; Math.hex(42) %]
__TEST__
66
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Math; Math.int(9.9) %]
__TEST__
9
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Math; Math.log(42).substr(0,15) %]
__TEST__
3.7376696182833
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Math; Math.oct(72) %]
__TEST__
58
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Math; Math.sin(0.304).substr(0,17) %]
__TEST__
0.299339178269093
__EXPECTED__

	# test method calling via autoload to get parameters
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% thing.a %] [% thing.a %]
[% thing.b %]
$thing.w
__TEST__
alpha alpha
bravo
whisky
__EXPECTED__

	# ditto to set parameters
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% thing.c = thing.b -%]
[% thing.c %]
__TEST__
bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% thing.concat = thing.b -%]
[% thing.args %]
__TEST__
ARGS: bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% thing.concat(d) = thing.b -%]
[% thing.args %]
__TEST__
ARGS: delta, bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% thing.yesterday %]
[% thing.today %]
[% thing.belief(thing.a thing.b thing.w) %]
__TEST__
Love was such an easy game to play...
Live for today and die for tomorrow.
Oh I believe in alpha and bravo and whisky.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Yesterday, $thing.yesterday
$thing.today
${thing.belief('yesterday')}
__TEST__
Yesterday, Love was such an easy game to play...
Live for today and die for tomorrow.
Oh I believe in yesterday.
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
thing.belief('fish' 'chips')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% thing.belief('fish' 'chips') %]
[% thing.belief %]
__TEST__
Oh I believe in fish and chips.
Oh I believe in <nothing>.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
${thing.belief('fish' 'chips')}
$thing.belief
__TEST__
Oh I believe in fish and chips.
Oh I believe in <nothing>.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% thing.tomorrow %]
$thing.tomorrow
__TEST__
Monday
Tuesday
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH [ 1 2 3 4 5 ] %]$thing.tomorrow [% END %].
__TEST__
Wednesday Thursday Friday Saturday Sunday .
__EXPECTED__

	#-----------------------------------------------------------------------
	# test private methods do not get exposed
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before[% thing._private %] mid [% thing._hidden %]after
__TEST__
before mid after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% key = '_private' -%]
[[% thing.$key %]]
__TEST__
[]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
thing.$key = 'foo'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% key = '.private' -%]
[[% thing.$key = 'foo' %]]
[[% thing.$key %]]
__TEST__
[]
[]
__EXPECTED__

	#-----------------------------------------------------------------------
	# test auto-stringification
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% string.stringify %]
__TEST__
stringified 'Test String'
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% string %]
__TEST__
stringified 'Test String'
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"-> $string <-"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "-> $string <-" %]
__TEST__
-> stringified 'Test String' <-
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "$string" %]
__TEST__
stringified 'Test String'
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
foo $string bar
__TEST__
foo stringified 'Test String' bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
.[% t1.dead %].
__TEST__
..
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY; t1.die; CATCH; error; END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
.[% TRY; t1.die; CATCH; error; END %].
__TEST__
.undef error - barfed up
.
__EXPECTED__

	#-----------------------------------------------------------------------
	# try and pin down the numification bug
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH item IN num.things -%]
* [% item %]
[% END -%]
__TEST__
* foo
* bar
* baz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% num %]
__TEST__
PASS: stringified Numbersome
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% getnum.num %]
__TEST__
PASS: stringified from GetNumbersome
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start $a
[% BLOCK a %]
this is a
[% END %]
=[% INCLUDE a %]=
=[% include a %]=
end
__TEST__
start $a

=
this is a
=
=
this is a
=
end
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
data.first; ' to '; data.last
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data.first; ' to '; data.last %]
__TEST__
11 to 42
__EXPECTED__

	# use tt2
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
begin
[% this will be ignored %]
[* a *]
end
__TEST__
begin
[% this will be ignored %]alpha
end
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
c = 'b'; 'hello'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
$b does nothing: 
[* c = 'b'; 'hello' *]
stuff: 
[* $c *]
__TEST__
$b does nothing: hello
stuff: b
__EXPECTED__

	# use tt3
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
begin
[% this will be ignored %]
<!-- a -->
end
__TEST__
begin
[% this will be ignored %]
alphaend
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
$b does something: 
<!-- c = 'b'; 'hello' -->
stuff: 
<!-- $c -->
end
__TEST__
bravo does something: 
hellostuff: 
bravoend
__EXPECTED__

	#-----------------------------------------------------------------------
	# tt4
	#-----------------------------------------------------------------------
	# use tt4
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
start $a[% 'include' = 'hello world' %]
[% BLOCK a -%]
this is a
[%- END %]
=[% INCLUDE a %]=
=[% include %]=
end
__TEST__
start $a

=this is a=
=hello world=
end
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
sql = "
     SELECT *
     FROM table"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% sql = "
     SELECT *
     FROM table"
-%]
SQL: [% sql %]
__TEST__
SQL: 
     SELECT *
     FROM table
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = "\a\b\c\ndef" -%]
a: [% a %]
__TEST__
a: abc
def
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
a = "\f\o\o"
   b = "a is '$a'"
   c = "b is \$100"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = "\f\o\o"
   b = "a is '$a'"
   c = "b is \$100"
-%]
a: [% a %]  b: [% b %]  c: [% c %]
__TEST__
a: foo  b: a is 'foo'  c: b is $100
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
tag = {
      a => "[\%"
      z => "%\]"
   }
   quoted = "[\% INSERT foo %\]"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% tag = {
      a => "[\%"
      z => "%\]"
   }
   quoted = "[\% INSERT foo %\]"
-%]
A directive looks like: [% tag.a %] INCLUDE foo [% tag.z %]
The quoted value is [% quoted %]
__TEST__
A directive looks like: [% INCLUDE foo %]
The quoted value is [% INSERT foo %]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
wintxt | replace("(\r\n){2,}", "\n<break>\n")
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
=[% wintxt | replace("(\r\n){2,}", "\n<break>\n") %]
__TEST__
=foo
<break>
bar
<break>
baz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% nl  = "\n"
   tab = "\t"
-%]
blah blah[% nl %][% tab %]x[% nl; tab %]y[% nl %]end
__TEST__
blah blah
	x
	y
end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
alist: [% $alist %]
__TEST__
alist: ??
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% foo.bar.baz %]
__TEST__
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE Table([2, 3, 5, 7, 11, 13], rows=2)
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
Table.row(0).join(', ')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Table([2, 3, 5, 7, 11, 13], rows=2) -%]
[% Table.row(0).join(', ') %]
__TEST__
2, 5, 11
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE table([17, 19, 23, 29, 31, 37], rows=2) -%]
[% table.row(0).join(', ') %]
__TEST__
17, 23, 31
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE t = Table([41, 43, 47, 49, 53, 59], rows=2) -%]
[% t.row(0).join(', ') %]
__TEST__
41, 47, 53
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE t = table([61, 67, 71, 73, 79, 83], rows=2) -%]
[% t.row(0).join(', ') %]
__TEST__
61, 71, 79
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE t = table([89, 97, 101, 103, 107, 109], rows=2)
__PARSED__

	# use tt1
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE t = table([89, 97, 101, 103, 107, 109], rows=2) -%]
[% t.row(0).join(', ') %]
__TEST__
89, 101, 107
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Foo(2) -%]
[% Foo.output %]
__TEST__
This is the Foo plugin, value is 2
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Bar(4) -%]
[% Bar.output %]
__TEST__
This is the Bar plugin, value is 4
__EXPECTED__

	# use tt2
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE t = table([113, 127, 131, 137, 139, 149], rows=2) -%]
[% t.row(0).join(', ') %]
__TEST__
113, 131, 139
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY -%]
[% USE Foo(8) -%]
[% Foo.output %]
[% CATCH -%]
ERROR: [% error.info %]
[% END %]
__TEST__
ERROR: Foo: plugin not found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE bar(16) -%]
[% bar.output %]
__TEST__
This is the Bar plugin, value is 16
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE qux = baz(32) -%]
[% qux.output %]
__TEST__
This is the Foo plugin, value is 32
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE wiz = cgi(64) -%]
[% wiz.output %]
__TEST__
This is the Bar plugin, value is 64
__EXPECTED__

	#-----------------------------------------------------------------------
	# LOAD_PERL
	#-----------------------------------------------------------------------
	# use tt3
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE baz = MyPlugs.Baz(128) -%]
[% baz.output %]
__TEST__
This is the Baz module, value is 128
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE boz = MyPlugs.Baz(256) -%]
[% boz.output %]
__TEST__
This is the Baz module, value is 256
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE mycgi = url('/cgi-bin/bar.pl', debug=1); %][% mycgi %]
__TEST__
/cgi-bin/bar.pl?debug=1
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE mycgi = UrL('/cgi-bin/bar.pl', debug=1);
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE mycgi = URL('/cgi-bin/bar.pl', debug=1); %][% mycgi %]
__TEST__
/cgi-bin/bar.pl?debug=1
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE mycgi = UrL('/cgi-bin/bar.pl', debug=1); %][% mycgi %]
__TEST__
/cgi-bin/bar.pl?debug=1
__EXPECTED__

	# use tt4
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Foo(20) -%]
[% Foo.output %]
__TEST__
This is the Foo plugin, value is 20
__EXPECTED__

	# use tt4
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY -%]
[% USE Date() -%]
[% CATCH -%]
ERROR: [% error.info %]
[% END %]
__TEST__
ERROR: Date: plugin not found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE mycgi = url('/cgi-bin/bar.pl', debug=1); %][% mycgi %]
__TEST__
/cgi-bin/bar.pl?debug=1
__EXPECTED__

	# use tt1
	# name Simple plugin filter
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Simple -%]
test 1: [% 'hello' | simple %]
[% INCLUDE simple2 %]
test 3: [% 'world' | simple %]
__TEST__
test 1: **hello**
test 2: **badger**
test 3: **world**
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
BLOCK foo; "This is foo!"; END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE foo %]
[% BLOCK foo; "This is foo!"; END %]
__TEST__
This is foo!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE foo+bar -%]
[% BLOCK foo; "This is foo!\n"; END %]
[% BLOCK bar; "This is bar!\n"; END %]
__TEST__
This is foo!
This is bar!
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
PROCESS foo+bar
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PROCESS foo+bar -%]
[% BLOCK foo; "This is foo!\n"; END %]
[% BLOCK bar; "This is bar!\n"; END %]
__TEST__
This is foo!
This is bar!
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
WRAPPER edge + box + indent
     title = "The Title"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% WRAPPER edge + box + indent
     title = "The Title" -%]
My content
[% END -%]
[% BLOCK indent -%]
<indent>
[% content -%]
</indent>
[% END -%]
[% BLOCK box -%]
<box>
[% content -%]
</box>
[% END -%]
[% BLOCK edge -%]
<edge>
[% content -%]
</edge>
[% END -%]
__TEST__
<edge>
<box>
<indent>
My content
</indent>
</box>
</edge>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INSERT foo+bar/baz %]
__TEST__
This is the foo file, a is [% a -%][% DEFAULT word = 'qux' -%]
This is file baz
The word is '[% word %]'
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
file1 = 'foo'
   file2 = 'bar/baz'
__PARSED__

	ok $tt._parse( q:to[__PARSED__] );
INSERT "$file1" + "$file2"
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% file1 = 'foo'
   file2 = 'bar/baz'
-%]
[% INSERT "$file1" + "$file2" %]
__TEST__
This is the foo file, a is [% a -%][% DEFAULT word = 'qux' -%]
This is file baz
The word is '[% word %]'
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE pod;
    pom = pod.parse("$podloc/no_such_file.pod");
    pom ? 'not ok' : 'ok'; ' - file does not exist';
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  USE pod;
    pom = pod.parse("$podloc/no_such_file.pod");
    pom ? 'not ok' : 'ok'; ' - file does not exist';
%]
__TEST__
ok - file does not exist
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE pod;
    pom = pod.parse("$podloc/test1.pod");
    pom ? 'ok' : 'not ok'; ' - file parsed';
    global.pom = pom;
    global.warnings = pod.warnings;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  USE pod;
    pom = pod.parse("$podloc/test1.pod");
    pom ? 'ok' : 'not ok'; ' - file parsed';
    global.pom = pom;
    global.warnings = pod.warnings;
%]
__TEST__
ok - file parsed
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  global.warnings.join("\n") %]
__TEST__
-- process --
spurious '>' at [% podloc %]/test1.pod line 17
spurious '>' at [% podloc %]/test1.pod line 21
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH h1 = global.pom.head1 -%]
* [% h1.title %]
[% END %]
__TEST__
* NAME
* SYNOPSIS
* DESCRIPTION
* THE END
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH h2 = global.pom.head1.2.head2 -%]
+ [% h2.title %]
[% END %]
__TEST__
+ First Subsection
+ Second Subsection
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
PROCESS $item.type FOREACH item=global.pom.head1.2.content
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PROCESS $item.type FOREACH item=global.pom.head1.2.content %]

[% BLOCK head2 -%]
<h2>[% item.title | trim %]</h2>
[% END %]

[% BLOCK text -%]
<p>[% item | trim %]</p>
[% END %]

[% BLOCK verbatim -%]
<pre>[% item | trim %]</pre>
[% END %]
__TEST__
<p>This is the description for My::Module.</p>
<pre>This is verbatim</pre>
<h2>First Subsection</h2>
<h2>Second Subsection</h2>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE foo a=10 %]
__TEST__
This is the foo file, a is 10
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE src:foo a=20
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE src:foo a=20 %]
__TEST__
This is the foo file, a is 20
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE all:foo a=30 %]
__TEST__
This is the foo file, a is 30
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY;
    INCLUDE lib:foo a=30 ;
   CATCH;
    error;
   END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY;
    INCLUDE lib:foo a=30 ;
   CATCH;
    error;
   END
%]
__TEST__
file error - lib:foo: not found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INSERT src:foo %]
__TEST__
This is the foo file, a is [% a -%]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
This is the first test
__TEST__
This is the main content wrapper for "untitled"
This is the first test
This is the end.
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
META title = 'Test 2'
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META title = 'Test 2' -%]
This is the second test
__TEST__
This is the main content wrapper for "Test 2"
This is the second test
This is the end.
__EXPECTED__

	# use tt2
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META title = 'Test 3' -%]
This is the third test
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
This is the main content wrapper for "Test 3"
This is the third test

This is the end.
footer
__EXPECTED__

	# use tt3
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META title = 'Test 3' -%]
This is the third test
__TEST__
header.tt2:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
footer
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE ProcFoo -%]
[% ProcFoo.foo %]
[% ProcFoo.bar %]
__TEST__
This is procfoofoo
This is procfoobar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE ProcBar -%]
[% ProcBar.foo %]
[% ProcBar.bar %]
[% ProcBar.baz %]
__TEST__
This is procfoofoo
This is procbarbar
This is procbarbaz
__EXPECTED__

	# use ttinc
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INCLUDE foo %]
[% INCLUDE $relfile %]
[% CATCH file %]
Error: [% error.type %] - [% error.info.split(': ').1 %]
[% END %]
__TEST__
This is the foo file, a is Error: file - not found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INCLUDE foo %]
[% INCLUDE $absfile %]
[% CATCH file %]
Error: [% error.type %] - [% error.info.split(': ').1 %]
[% END %]
__TEST__
This is the foo file, a is Error: file - not found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INSERT foo +%]
[% INSERT $absfile %]
[% CATCH file %]
Error: [% error %]
[% END %]
__TEST__
-- process --
[% TAGS [* *] %]
This is the foo file, a is [% a -%]
Error: file error - [* absfile *]: not found
__EXPECTED__

	# use ttrel
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INCLUDE $relfile %]
[% INCLUDE foo %]
[% CATCH file -%]
Error: [% error.type %] - [% error.info %]
[% END %]
__TEST__
This is the foo file, a is Error: file - foo: not found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INCLUDE $relfile -%]
[% INCLUDE $absfile %]
[% CATCH file %]
Error: [% error.type %] - [% error.info.split(': ').1 %]
[% END %]
__TEST__
This is the foo file, a is Error: file - absolute paths are not allowed (set ABSOLUTE option)
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY; INSERT foo;      CATCH; "$error\n"; END
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
foo: [% TRY; INSERT foo;      CATCH; "$error\n"; END %]
rel: [% TRY; INSERT $relfile; CATCH; "$error\n"; END +%]
abs: [% TRY; INSERT $absfile; CATCH; "$error\n"; END %]
__TEST__
-- process --
[% TAGS [* *] %]
foo: file error - foo: not found
rel: This is the foo file, a is [% a -%]
abs: file error - [* absfile *]: absolute paths are not allowed (set ABSOLUTE option)
__EXPECTED__

	# use ttabs
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INCLUDE $absfile %]
[% INCLUDE foo %]
[% CATCH file %]
Error: [% error.type %] - [% error.info %]
[% END %]
__TEST__
This is the foo file, a is Error: file - foo: not found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% INCLUDE $absfile %]
[% INCLUDE $relfile %]
[% CATCH file %]
Error: [% error.type %] - [% error.info.split(': ').1 %]
[% END %]
__TEST__
This is the foo file, a is Error: file - relative paths are not allowed (set RELATIVE option)
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
foo: [% TRY; INSERT foo;      CATCH; "$error\n"; END %]
rel: [% TRY; INSERT $relfile; CATCH; "$error\n"; END %]
abs: [% TRY; INSERT $absfile; CATCH; "$error\n"; END %]
__TEST__
-- process --
[% TAGS [* *] %]
foo: file error - foo: not found
rel: file error - [* relfile *]: relative paths are not allowed (set RELATIVE option)
abs: This is the foo file, a is [% a -%]
__EXPECTED__

	# use ttinc
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE foobar %]
__TEST__
This is the old content
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
CALL fixfile('This is the new content')
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% CALL fixfile('This is the new content') %]
[% INCLUDE foobar %]
__TEST__
This is the new content
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
PROCESS baz a='alpha' | trim
__PARSED__

	# use ttd1
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
foo: [% PROCESS foo | trim +%]
bar: [% PROCESS bar | trim +%]
baz: [% PROCESS baz a='alpha' | trim %]
__TEST__
foo: This is one/foo
bar: This is two/bar
baz: This is the baz file, a: alpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
foo: [% INSERT foo | trim +%]
bar: [% INSERT bar | trim +%]
__TEST__
foo: This is one/foo
bar: This is two/bar
__EXPECTED__

	# use ttd2
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
foo: [% PROCESS foo | trim +%]
bar: [% PROCESS bar | trim +%]
baz: [% PROCESS baz a='alpha' | trim %]
__TEST__
foo: This is two/foo
bar: This is two/bar
baz: This is the baz file, a: alpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
foo: [% INSERT foo | trim +%]
bar: [% INSERT bar | trim +%]
__TEST__
foo: This is two/foo
bar: This is two/bar
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY; INCLUDE foo; CATCH; e; END
__PARSED__

	# use ttdbad
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY; INCLUDE foo; CATCH; e; END %]
__TEST__
file error - INCLUDE_PATH exceeds 42 directories
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
a: [% a %]
a(5): [% a(5) %]
a(5,10): [% a(5,10) %]
__TEST__
a: a sub []
a(5): a sub [5]
a(5,10): a sub [5, 10]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
b = \a
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% b = \a -%]
b: [% b %]
b(5): [% b(5) %]
b(5,10): [% b(5,10) %]
__TEST__
b: a sub []
b(5): a sub [5]
b(5,10): a sub [5, 10]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
c = \a(10,20)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% c = \a(10,20) -%]
c: [% c %]
c(30): [% c(30) %]
c(30,40): [% c(30,40) %]
__TEST__
c: a sub [10, 20]
c(30): a sub [10, 20, 30]
c(30,40): a sub [10, 20, 30, 40]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
z(\a)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% z(\a) %]
__TEST__
z called a sub [10, 20, 30]
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
f = \j.k
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f = \j.k -%]
f: [% f %]
__TEST__
f: 3
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
f = \j.m.n
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f = \j.m.n -%]
f: [% f %]
f(11): [% f(11) %]
__TEST__
f: nsub []
f(11): nsub [11]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% hashobj.bar.join %]
__TEST__
hash object method called in array context
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE scalar -%]
[% hashobj.scalar.bar %]
__TEST__
hash object method called in scalar context
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% listobj.bar.join %]
__TEST__
list object method called in array context
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE scalar -%]
[% listobj.scalar.bar %]
__TEST__
list object method called in scalar context
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
hash = { a = 10 }; 
   TRY; hash.scalar.a; CATCH; error; END;
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash = { a = 10 }; 
   TRY; hash.scalar.a; CATCH; error; END;
%]
__TEST__
scalar error - invalid object method: a
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
subref(10, 20).join
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% subref(10, 20).join %]
__TEST__
subroutine called in array context 10 20
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
USE scalar; scalar.subref(30, 40)
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE scalar; scalar.subref(30, 40) %]
__TEST__
subroutine called in scalar context 30 40
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
This is some text
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
This is some text
footer
__EXPECTED__

	# test that the 'demo' block (template sub) is defined
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE demo %]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
This is a demo
footer
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE astext a = 'artifact'
__PARSED__

	# and also the 'astext' block (template text)
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE astext a = 'artifact' %]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
Another template block, a is 'artifact'
footer
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
THROW barf 'Not feeling too good'
__PARSED__

	# test that 'barf' exception gets redirected to the correct
	# error template
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% THROW barf 'Not feeling too good' %]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
barfed: [barf] [Not feeling too good]
footer
__EXPECTED__

	# test all other errors get redirected correctly
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE no_such_file %]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
error: [file] [no_such_file: not found]
footer
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
INCLUDE block1
   a = 'alpha'
__PARSED__

	# import some block definitions from 'blockdef'...
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PROCESS blockdef -%]
[% INCLUDE block1
   a = 'alpha'
%]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
start of blockdef

end of blockdef
This is block 1, defined in blockdef, a is alpha

footer
__EXPECTED__

	# ...and make sure they go away for the next service
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE block1 %]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
error: [file] [block1: not found]
footer
__EXPECTED__

	# now try it again with AUTO_RESET turned off...
	# use tt2
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% PROCESS blockdef -%]
[% INCLUDE block1
   a = 'alpha'
%]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
start of blockdef

end of blockdef
This is block 1, defined in blockdef, a is alpha

footer
__EXPECTED__

	# ...and the block definitions should persist
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE block1 a = 'alpha' %]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
This is block 1, defined in blockdef, a is alpha

footer
__EXPECTED__

	# test that the 'demo' block is still defined
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE demo %]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
This is a demo
footer
__EXPECTED__

	# and also the 'astext' block
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% INCLUDE astext a = 'artifact' %]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
Another template block, a is 'artifact'
footer
__EXPECTED__

	# test that a single ERROR template can be specified
	# use tt3
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% THROW food 'cabbages' %]
__TEST__
header:
  title: Joe Random Title
  menu: This is the menu, defined in 'config'
barfed: [food] [cabbages]
footer
__EXPECTED__

	# use wrapper
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% title = 'The Foo Page' -%]
begin page content
title is "[% title %]"
end page content
__TEST__
This comes before
<outer title="The Foo Page">
begin process
begin page content
title is "The Foo Page"
end page content
end process
</outer>
This comes after
__EXPECTED__

	# use nested
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% title = 'The Bar Page' -%]
begin page content
title is "[% title %]"
end page content
__TEST__
This comes before
<outer title="inner The Bar Page">
<inner title="The Bar Page">
begin process
begin page content
title is "The Bar Page"
end page content
end process
</inner>

</outer>
This comes after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
__TEST__
alpha
__EXPECTED__

	# this is the second test
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% b %]
__TEST__
bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% numbers.join(', ') %]
__TEST__
1, 2, 3
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% numbers.scalar %]
__TEST__
one two three
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% numbers.ref %]
__TEST__
CODE
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
a: [% a %]
__TEST__
a: 
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
TRY; a; CATCH; "ERROR: $error"; END
__PARSED__

	# use warn
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY; a; CATCH; "ERROR: $error"; END %]
__TEST__
ERROR: undef error - a is undefined
__EXPECTED__

	# use default
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myitem = 'foo' -%]
1: [% myitem %]
2: [% myitem.item %]
3: [% myitem.item.item %]
__TEST__
1: foo
2: foo
3: foo
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
"* $item\n" FOREACH item = myitem
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myitem = 'foo' -%]
[% "* $item\n" FOREACH item = myitem -%]
[% "+ $item\n" FOREACH item = myitem.list %]
__TEST__
* foo
+ foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myitem = 'foo' -%]
[% myitem.hash.value %]
__TEST__
foo
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
myitem = 'foo'
   mylist = [ 'one', myitem, 'three' ]
   global.mylist = mylist
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myitem = 'foo'
   mylist = [ 'one', myitem, 'three' ]
   global.mylist = mylist
-%]
[% mylist.item %]
0: [% mylist.item(0) %]
1: [% mylist.item(1) %]
2: [% mylist.item(2) %]
__TEST__
one
0: one
1: foo
2: three
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "* $item\n" FOREACH item = global.mylist -%]
[% "+ $item\n" FOREACH item = global.mylist.list -%]
__TEST__
* one
* foo
* three
+ one
+ foo
+ three
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
global.mylist.push('bar');
   "* $item.key => $item.value\n" FOREACH item = global.mylist.hash
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.mylist.push('bar');
   "* $item.key => $item.value\n" FOREACH item = global.mylist.hash -%]
__TEST__
* one => foo
* three => bar
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
myhash = { msg => 'Hello World', things => global.mylist, a => 'alpha' };
   global.myhash = myhash 
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myhash = { msg => 'Hello World', things => global.mylist, a => 'alpha' };
   global.myhash = myhash 
-%]
* [% myhash.item('msg') %]
__TEST__
* Hello World
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.myhash.delete('things') -%]
keys: [% global.myhash.keys.sort.join(', ') %]
__TEST__
keys: a, msg
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "* $item\n" 
    FOREACH item IN global.myhash.items.sort -%]
__TEST__
* a
* alpha
* Hello World
* msg
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
items = [ 'foo', 'bar', 'baz' ];
   take  = [ 0, 2 ];
   slice = items.$take;
   slice.join(', ');
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% items = [ 'foo', 'bar', 'baz' ];
   take  = [ 0, 2 ];
   slice = items.$take;
   slice.join(', ');
%]
__TEST__
foo, baz
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
items = {
    foo = 'one',
    bar = 'two',
    baz = 'three'
   }
   take  = [ 'foo', 'baz' ];
   slice = items.$take;
   slice.join(', ');
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% items = {
    foo = 'one',
    bar = 'two',
    baz = 'three'
   }
   take  = [ 'foo', 'baz' ];
   slice = items.$take;
   slice.join(', ');
%]
__TEST__
one, three
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
items = {
    foo = 'one',
    bar = 'two',
    baz = 'three'
   }
   keys = items.keys.sort;
   items.${keys}.join(', ');
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% items = {
    foo = 'one',
    bar = 'two',
    baz = 'three'
   }
   keys = items.keys.sort;
   items.${keys}.join(', ');
%]
__TEST__
two, three, one
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% obj.name %]
__TEST__
an object
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% obj.name.list.first %]
__TEST__
an object
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% obj.items.first %]
__TEST__
name
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% obj.items.1 %]
__TEST__
an object
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% bop.first.name %]
__TEST__
an object
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% listobj.0 %] / [% listobj.first %]
__TEST__
10 / 10
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% listobj.2 %] / [% listobj.last %]
__TEST__
30 / 30
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% listobj.join(', ') %]
__TEST__
10, 20, 30
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
=[% size %]=
__TEST__
==
__EXPECTED__

	ok $tt._parse( q:to[__PARSED__] );
foo = { "one" = "bar" "" = "empty" }
__PARSED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% foo = { "one" = "bar" "" = "empty" } -%]
foo is { [% FOREACH k IN foo.keys.sort %]"[% k %]" = "[% foo.$k %]" [% END %]}
setting foo.one to baz
[% fookey = "one" foo.$fookey = "baz" -%]
foo is { [% FOREACH k IN foo.keys.sort %]"[% k %]" = "[% foo.$k %]" [% END %]}
setting foo."" to quux
[% fookey = "" foo.$fookey = "full" -%]
foo is { [% FOREACH k IN foo.keys.sort %]"[% k %]" = "[% foo.$k %]" [% END %]}
--expect --
foo is { "" = "empty" "one" = "bar" }
setting foo.one to baz
foo is { "" = "empty" "one" = "baz" }
setting foo."" to quux
foo is { "" = "full" "one" = "baz" }
__EXPECTED__

	# test Dave Howorth's patch (v2.15) which makes the stash more strict
	# about what it considers to be a missing method error
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hashobj.hello %]
__TEST__
Hello World
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY; hashobj.goodbye; CATCH; "ERROR: "; clean(error); END %]
__TEST__
ERROR: undef error - Can't locate object method "no_such_method" via package "HashObject"
__EXPECTED__

	#-----------------------------------------------------------------------
	# try and pin down the numification bug
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH item IN num.things -%]
* [% item %]
[% END -%]
__TEST__
* foo
* bar
* baz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% num %]
__TEST__
PASS: stringified Numbersome
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% getnum.num %]
__TEST__
PASS: stringified from GetNumbersome
__EXPECTED__

	# Exercise the object with the funky overloaded comparison
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% cmp_ol.hello %]
__TEST__
Hello
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name scalar list method --
[% foo = 'bar'; foo.join %]
__TEST__
bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
a: [% a %]
__TEST__
a: 
__EXPECTED__

	# use warn
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY; a; CATCH; "ERROR: $error"; END %]
__TEST__
ERROR: undef error - a is undefined
__EXPECTED__

	# use default
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myitem = 'foo' -%]
1: [% myitem %]
2: [% myitem.item %]
3: [% myitem.item.item %]
__TEST__
1: foo
2: foo
3: foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myitem = 'foo' -%]
[% "* $item\n" FOREACH item = myitem -%]
[% "+ $item\n" FOREACH item = myitem.list %]
__TEST__
* foo
+ foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myitem = 'foo' -%]
[% myitem.hash.value %]
__TEST__
foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myitem = 'foo'
   mylist = [ 'one', myitem, 'three' ]
   global.mylist = mylist
-%]
[% mylist.item %]
0: [% mylist.item(0) %]
1: [% mylist.item(1) %]
2: [% mylist.item(2) %]
__TEST__
one
0: one
1: foo
2: three
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "* $item\n" FOREACH item = global.mylist -%]
[% "+ $item\n" FOREACH item = global.mylist.list -%]
__TEST__
* one
* foo
* three
+ one
+ foo
+ three
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.mylist.push('bar');
   "* $item.key => $item.value\n" FOREACH item = global.mylist.hash -%]
__TEST__
* one => foo
* three => bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% myhash = { msg => 'Hello World', things => global.mylist, a => 'alpha' };
   global.myhash = myhash 
-%]
* [% myhash.item('msg') %]
__TEST__
* Hello World
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.myhash.delete('things') -%]
keys: [% global.myhash.keys.sort.join(', ') %]
__TEST__
keys: a, msg
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "* $item\n" 
    FOREACH item IN global.myhash.items.sort -%]
__TEST__
* a
* alpha
* Hello World
* msg
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% items = [ 'foo', 'bar', 'baz' ];
   take  = [ 0, 2 ];
   slice = items.$take;
   slice.join(', ');
%]
__TEST__
foo, baz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name slice of lemon --
[% items = {
    foo = 'one',
    bar = 'two',
    baz = 'three'
   }
   take  = [ 'foo', 'baz' ];
   slice = items.$take;
   slice.join(', ');
%]
__TEST__
one, three
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name slice of toast --
[% items = {
    foo = 'one',
    bar = 'two',
    baz = 'three'
   }
   keys = items.keys.sort;
   items.${keys}.join(', ');
%]
__TEST__
two, three, one
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% i = 0 %]
[%- a = [ 0, 1, 2 ] -%]
[%- WHILE i < 3 -%]
[%- i %][% a.$i -%]
[%- i = i + 1 -%]
[%- END %]
__TEST__
001122
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%- a = [ "alpha", "beta", "gamma", "delta" ] -%]
[%- b = "foo" -%]
[%- a.$b -%]
__TEST__
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%- a = [ "alpha", "beta", "gamma", "delta" ] -%]
[%- b = "2" -%]
[%- a.$b -%]
__TEST__
gamma
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% obj.name %]
__TEST__
an object
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% obj.name.list.first %]
__TEST__
an object
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name bop --
[% bop.first.name %]
__TEST__
an object
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% obj.items.first %]
__TEST__
name
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% obj.items.1 %]
__TEST__
an object
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
=[% size %]=
__TEST__
==
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Dumper;
   TRY;
     correct(["hello", "there"]);
   CATCH;
     error.info.join(', ');
   END;
%]
==
[% TRY;
     buggy.croak(["hello", "there"]);
   CATCH;
     error.info.join(', ');
   END;
%]
__TEST__
hello, there
==
hello, there
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash = { }
   list = [ hash ]
   list.last.message = 'Hello World';
   "message: $list.last.message\n"
-%]
__TEST__
message: Hello World
__EXPECTED__

	# test Dave Howorth's patch (v2.15) which makes the stash more strict
	# about what it considers to be a missing method error
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hashobj.hello %]
__TEST__
Hello World
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY; hashobj.goodbye; CATCH; "ERROR: "; clean(error); END %]
__TEST__
ERROR: undef error - Can't locate object method "no_such_method" via package "HashObject"
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY; 
    hashobj.now_is_the_time_to_test_a_very_long_method_to_see_what_happens;
   CATCH; 
     "ERROR: "; clean(error); 
   END 
%]
__TEST__
ERROR: undef error - Can't locate object method "this_method_does_not_exist" via package "HashObject"
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% foo = { "one" = "bar" "" = "empty" } -%]
foo is { [% FOREACH k IN foo.keys.sort %]"[% k %]" = "[% foo.$k %]" [% END %]}
setting foo.one to baz
[% fookey = "one" foo.$fookey = "baz" -%]
foo is { [% FOREACH k IN foo.keys.sort %]"[% k %]" = "[% foo.$k %]" [% END %]}
setting foo."" to quux
[% fookey = "" foo.$fookey = "full" -%]
foo is { [% FOREACH k IN foo.keys.sort %]"[% k %]" = "[% foo.$k %]" [% END %]}
--expect --
foo is { "" = "empty" "one" = "bar" }
setting foo.one to baz
foo is { "" = "empty" "one" = "baz" }
setting foo."" to quux
foo is { "" = "full" "one" = "baz" }
__EXPECTED__

	# Exercise the object with the funky overloaded comparison
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% cmp_ol.hello %]
__TEST__
Hello
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Before
[%  TRY;
        str_eval_die;
    CATCH;
        "caught error: $error";
    END;
%]
After
__TEST__
Before
str_eval_die returned
After
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  str_eval_die %]
__TEST__
str_eval_die returned
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name ASCII key --
ascii = [% ascii %]
hash.$ascii = [% hash.$ascii %]
__TEST__
ascii = key
hash.$ascii = value
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name UTF8 length --
str.length = [% str.length %]
__TEST__
str.length = 4
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name UTF8 key fetch --
utf8 = [% utf8 %]
hash.$utf8 = hash.[% utf8 %] = [% hash.$utf8 %]
__TEST__
utf8 = ÐºÐ»ÑÑ
hash.$utf8 = hash.ÐºÐ»ÑÑ = Ð·Ð½Ð°ÑÐµÐ½Ð¸Ðµ
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name UTF8 key assign --
[% value = hash.$utf8; hash.$value = utf8 -%]
value = [% value %]
hash.$value = hash.[% value %] = [% hash.$value %]
__TEST__
value = Ð·Ð½Ð°ÑÐµÐ½Ð¸Ðµ
hash.$value = hash.Ð·Ð½Ð°ÑÐµÐ½Ð¸Ðµ = ÐºÐ»ÑÑ
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
This is some text
[% STOP %]
More text
__TEST__
This is some text
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
This is some text
[% halt %]
More text
__TEST__
This is some text
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
This is some text
[% INCLUDE halt1 %]
More text
__TEST__
This is some text
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
This is some text
[% INCLUDE myblock1 %]
More text
[% BLOCK myblock1 -%]
This is myblock1
[% STOP %]
more of myblock1
[% END %]
__TEST__
This is some text
This is myblock1
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
This is some text
[% INCLUDE myblock2 %]
More text
[% BLOCK myblock2 -%]
This is myblock2
[% halt %]
more of myblock2
[% END %]
__TEST__
This is some text
This is myblock2
__EXPECTED__

	#-----------------------------------------------------------------------
	# ensure 'stop' exceptions get ignored by TRY...END blocks
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY -%]
trying
[% STOP -%]
tried
[% CATCH -%]
caught [[% error.type %]] - [% error.info %]
[% END %]
after
__TEST__
before
trying
__EXPECTED__

	#-----------------------------------------------------------------------
	# ensure PRE_PROCESS and POST_PROCESS templates get added with STOP
	#-----------------------------------------------------------------------
	# use wrapped
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
This is some text
[% STOP %]
More text
__TEST__
This is the header
This is some text
This is the footer
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% foo = 'the foo string'
   bar = 'the bar string'
   baz = foo _ ' and ' _ bar
-%]
baz: [% baz %]
__TEST__
baz: the foo string and the bar string
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name defined variable --
[% foo %]
__TEST__
10
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name variable with undefined value --
[% TRY; bar; CATCH; error; END %]
__TEST__
var.undef error - undefined variable: bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name dotted variable with undefined value --
[% TRY; baz.boz; CATCH; error; END %]
__TEST__
var.undef error - undefined variable: baz.boz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name undefined first part of dotted.variable --
[% TRY; wiz.bang; CATCH; error; END %]
__TEST__
var.undef error - undefined variable: wiz.bang
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name undefined second part of dotted.variable --
[% TRY; baz.booze; CATCH; error; END %]
__TEST__
var.undef error - undefined variable: baz.booze
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name dotted.variable with args --
[% TRY; baz(10).booze(20, 'blah', "Foo $foo"); CATCH; error; END %]
__TEST__
var.undef error - undefined variable: baz(10).booze(20, 'blah', 'Foo 10')
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String -%]
string: [[% String.text %]]
__TEST__
string: []
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String 'hello world' -%]
string: [[% String.text %]]
__TEST__
string: [hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String text='hello world' -%]
string: [[% String.text %]]
__TEST__
string: [hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String -%]
string: [[% String %]]
__TEST__
string: []
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String 'hello world' -%]
string: [[% String %]]
__TEST__
string: [hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String text='hello world' -%]
string: [[% String %]]
__TEST__
string: [hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String text='hello' -%]
string: [[% String.append(' world') %]]
string: [[% String %]]
__TEST__
string: [hello world]
string: [hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String text='hello' -%]
[% copy = String.copy -%]
string: [[% String %]]
string: [[% copy %]]
__TEST__
string: [hello]
string: [hello]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String -%]
[% hi = String.new('hello') -%]
[% lo = String.new('world') -%]
[% hw = String.new(text="$hi $lo") -%]
hi: [[% hi %]]
lo: [[% lo %]]
hw: [[% hw %]]
__TEST__
hi: [hello]
lo: [world]
hw: [hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE hi = String 'hello' -%]
[% lo = hi.new('world') -%]
hi: [[% hi %]]
lo: [[% lo %]]
__TEST__
hi: [hello]
lo: [world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE hi = String 'hello' -%]
[% lo = hi.copy -%]
hi: [[% hi %]]
lo: [[% lo %]]
__TEST__
hi: [hello]
lo: [hello]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE hi = String 'hello' -%]
[% lo = hi.copy.append(' world') -%]
hi: [[% hi %]]
lo: [[% lo %]]
__TEST__
hi: [hello]
lo: [hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE hi = String 'hello' -%]
[% lo = hi.new('hey').append(' world') -%]
hi: [[% hi %]]
lo: [[% lo %]]
__TEST__
hi: [hello]
lo: [hey world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE hi=String "hello world\n" -%]
hi: [[% hi %]]
[% lo = hi.chomp -%]
hi: [[% hi %]]
lo: [[% lo %]]
__TEST__
hi: [hello world
]
hi: [hello world]
lo: [hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE foo=String "foop" -%]
[[% foo.chop %]]
[[% foo.chop %]]
__TEST__
[foo]
[fo]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE hi=String "hello" -%]
  left: [[% hi.copy.left(11) %]]
 right: [[% hi.copy.right(11) %]]
center: [[% hi.copy.center(11) %]]
centre: [[% hi.copy.centre(12) %]]
__TEST__
  left: [hello      ]
 right: [      hello]
center: [   hello   ]
centre: [   hello    ]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE str=String('hello world') -%]
 hi: [[% str.upper %]]
 hi: [[% str %]]
 lo: [[% str.lower %]]
cap: [[% str.capital %]]
__TEST__
 hi: [HELLO WORLD]
 hi: [HELLO WORLD]
 lo: [hello world]
cap: [Hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE str=String('hello world') -%]
len: [[% str.length %]]
__TEST__
len: [11]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE str=String("   \n\n\t\r hello\nworld\n\r  \n \r") -%]
[[% str.trim %]]
__TEST__
[hello
world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE str=String("   \n\n\t\r hello  \n \n\r world\n\r  \n \r") -%]
[[% str.collapse %]]
__TEST__
[hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE str=String("hello") -%]
[[% str.append(' world') %]]
[[% str.prepend('well, ') %]]
__TEST__
[hello world]
[well, hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE str=String("hello") -%]
[[% str.push(' world') %]]
[[% str.unshift('well, ') %]]
__TEST__
[hello world]
[well, hello world]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE str=String('foo bar') -%]
[[% str.copy.pop(' bar') %]]
[[% str.copy.shift('foo ') %]]
__TEST__
[foo]
[bar]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE str=String('Hello World') -%]
[[% str.copy.truncate(5) %]]
[[% str.copy.truncate(8, '...') %]]
[[% str.copy.truncate(20, '...') %]]
__TEST__
[Hello]
[Hello...]
[Hello World]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('foo') -%]
[[% String.append(' ').repeat(4) %]]
__TEST__
[foo foo foo foo ]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('foo') -%]
[% String.format("[%s]") %]
__TEST__
[foo]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('foo bar foo baz') -%]
[[% String.replace('foo', 'oof') %]]
__TEST__
[oof bar oof baz]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('foo bar foo baz') -%]
[[% String.copy.remove('foo\s*') %]]
[[% String.copy.remove('ba[rz]\s*') %]]
__TEST__
[bar baz]
[foo foo ]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('foo bar foo baz') -%]
[[% String.split.join(', ') %]]
__TEST__
[foo, bar, foo, baz]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('foo bar foo baz') -%]
[[% String.split(' bar ').join(', ') %]]
__TEST__
[foo, foo baz]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('foo bar foo baz') -%]
[[% String.split(' bar ').join(', ') %]]
__TEST__
[foo, foo baz]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('foo bar foo baz') -%]
[[% String.split('\s+').join(', ') %]]
__TEST__
[foo, bar, foo, baz]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('foo bar foo baz') -%]
[[% String.split('\s+', 2).join(', ') %]]
__TEST__
[foo, bar foo baz]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('foo bar foo baz') -%]
[% String.search('foo') ? 'ok' : 'not ok' %]
[% String.search('fooz') ? 'not ok' : 'ok' %]
[% String.search('^foo') ? 'ok' : 'not ok' %]
[% String.search('^bar') ? 'not ok' : 'ok' %]
__TEST__
ok
ok
ok
ok
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String 'foo < bar' filter='html' -%]
[% String %]
__TEST__
foo &lt; bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String 'foo bar' filter='uri' -%]
[% String %]
__TEST__
foo%20bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String 'foo bar' filters='uri' -%]
[% String %]
__TEST__
foo%20bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String '   foo bar    ' filters=['trim' 'uri'] -%]
[[% String %]]
__TEST__
[foo%20bar]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String '   foo bar    ' filter='trim, uri' -%]
[[% String %]]
__TEST__
[foo%20bar]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String '   foo bar    ' filters='trim, uri' -%]
[[% String %]]
__TEST__
[foo%20bar]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String 'foo bar' filters={ replace=['bar', 'baz'],
				  trim='', uri='' } -%]
[[% String %]]
__TEST__
[foo%20baz]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String 'foo bar' filters=[ 'replace', ['bar', 'baz'],
				  'trim', 'uri' ] -%]
[[% String %]]
__TEST__
[foo%20baz]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String 'foo bar' -%]
[% String %]
[% String.filter('uri') %]
[% String.filter('replace', 'bar', 'baz') %]
[% String.output_filter('uri') -%]
[% String %]
[% String.output_filter({ repeat => [3] }) -%]
[% String %]
__TEST__
foo bar
foo%20bar
foo baz
foo%20bar
foo%20barfoo%20barfoo%20bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String;
   a = 'HeLLo';
   b = 'hEllO';
   a == b ? "not ok 0\n" : "ok 0\n";
   String.new(a) == String.new(b) ? "not ok 1\n" : "ok 1\n";
   String.new(a).lower == String.new(b).lower ? "ok 2\n" : "not ok 2\n";
   String.new(a).lower.equals(String.new(b).lower) ? "ok 3\n" : "not ok 3\n";
   a.search("(?i)^$b\$") ? "ok 4\n" : "not ok 4\n";
-%]
__TEST__
ok 0
ok 1
ok 2
ok 3
ok 4
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE String('Hello World') -%]
a: [% String.substr(6) %]!
b: [% String.substr(0, 5) %]!
c: [% String.substr(0, 5, 'Goodbye') %]!
d: [% String %]!
__TEST__
a: World!
b: Hello!
c: Hello!
d: Goodbye World!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE str = String('foo bar baz wiz waz woz') -%]
a: [% str.substr(4, 3) %]
b: [% str.substr(12) %]
c: [% str.substr(0, 11, 'FOO') %]
d: [% str %]
__TEST__
a: bar
b: wiz waz woz
c: foo bar baz
d: FOO wiz waz woz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% END %]
after
__TEST__
before
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE x %]
not matched
[% END %]
after
__TEST__
before
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE not_defined %]
not matched
[% END %]
after
__TEST__
before
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE 'alpha' %]
matched
[% END %]
after
__TEST__
before
matched
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE a %]
matched
[% END %]
after
__TEST__
before
matched
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH 'alpha' %]
this is ignored
[% CASE a %]
matched
[% END %]
after
__TEST__
before
matched
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE b %]
matched
[% END %]
after
__TEST__
before
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE a %]
matched
[% CASE b %]
not matched
[% END %]
after
__TEST__
before
matched
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE b %]
not matched
[% CASE a %]
matched
[% END %]
after
__TEST__
before
matched
after
__EXPECTED__

	#-----------------------------------------------------------------------
	# test default case
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE a %]
matched
[% CASE b %]
not matched
[% CASE %]
default not matched
[% END %]
after
__TEST__
before
matched
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE a %]
matched
[% CASE b %]
not matched
[% CASE DEFAULT %]
default not matched
[% END %]
after
__TEST__
before
matched
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE z %]
not matched
[% CASE x %]
not matched
[% CASE %]
default matched
[% END %]
after
__TEST__
before
default matched
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE z %]
not matched
[% CASE x %]
not matched
[% CASE DEFAULT %]
default matched
[% END %]
after
__TEST__
before
default matched
after
__EXPECTED__

	#-----------------------------------------------------------------------
	# test multiple matches
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE [ a b c ] %]
matched
[% CASE d %]
not matched
[% CASE %]
default not matched
[% END %]
after
__TEST__
before
matched
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% SWITCH a %]
this is ignored
[% CASE [ a b c ] %]
matched
[% CASE a %]
not matched, no drop-through
[% CASE DEFAULT %]
default not matched
[% END %]
after
__TEST__
before
matched
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% foo = 'a(b)'
   bar = 'a(b)';

   SWITCH foo;
     CASE bar;
       'ok';
     CASE;
       'not ok';
   END 
%]
__TEST__
ok
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE table(alphabet, rows=5) %]
[% FOREACH letter = table.col(0) %]
[% letter %]..
[%- END +%]
[% FOREACH letter = table.col(1) %]
[% letter %]..
[%- END %]
__TEST__
a..b..c..d..e..
f..g..h..i..j..
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE table(alphabet, rows=5) %]
[% FOREACH letter = table.row(0) %]
[% letter %]..
[%- END +%]
[% FOREACH letter = table.row(1) %]
[% letter %]..
[%- END %]
__TEST__
a..f..k..p..u..z..
b..g..l..q..v....
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE table(alphabet, rows=3) %]
[% FOREACH col = table.cols %]
[% col.0 %] [% col.1 %] [% col.2 +%]
[% END %]
__TEST__
a b c
d e f
g h i
j k l
m n o
p q r
s t u
v w x
y z 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE alpha = table(alphabet, cols=3, pad=0) %]
[% FOREACH group = alpha.col %]
[ [% group.first %] - [% group.last %] ([% group.size %] letters) ]
[% END %]
__TEST__
[ a - i (9 letters) ]
[ j - r (9 letters) ]
[ s - z (8 letters) ]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE alpha = table(alphabet, rows=5, pad=0, overlap=1) %]
[% FOREACH group = alpha.col %]
[ [% group.first %] - [% group.last %] ([% group.size %] letters) ]
[% END %]
__TEST__
[ a - e (5 letters) ]
[ e - i (5 letters) ]
[ i - m (5 letters) ]
[ m - q (5 letters) ]
[ q - u (5 letters) ]
[ u - y (5 letters) ]
[ y - z (2 letters) ]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE table(alphabet, rows=5, pad=0) %]
[% FOREACH col = table.cols %]
[% col.join('-') +%]
[% END %]
__TEST__
a-b-c-d-e
f-g-h-i-j
k-l-m-n-o
p-q-r-s-t
u-v-w-x-y
z
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE table(alphabet, rows=8, overlap=1 pad=0) %]
[% FOREACH col = table.cols %]
[% FOREACH item = col %][% item %] [% END +%]
[% END %]
__TEST__
a b c d e f g h 
h i j k l m n o 
o p q r s t u v 
v w x y z 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE table([1,3,5], cols=5) %]
[% FOREACH t = table.rows %]
[% t.join(', ') %]
[% END %]
__TEST__
1, 3, 5
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
>
[% USE table(empty, rows=3) -%]
[% FOREACH col = table.cols -%]
col
[% FOREACH item = col -%]
item: [% item -%]
[% END -%]
[% END -%]
<
__TEST__
>
<
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%a%] [% a %] [% a %]
__TEST__
alpha alpha alpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Redefining tags
[% TAGS (+ +) %]
[% a %]
[% b %]
(+ c +)
__TEST__
Redefining tags

[% a %]
[% b %]
charlie
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
[% TAGS (+ +) %]
[% a %]
%% b %%
(+ c +)
(+ TAGS <* *> +)
(+ d +)
<* e *>
__TEST__
alpha

[% a %]
%% b %%
charlie

(+ d +)
echo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TAGS default -%]
[% a %]
%% b %%
(+ c +)
__TEST__
alpha
%% b %%
(+ c +)
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
# same as 'default'
[% TAGS template -%]
[% a %]
%% b %%
(+ c +)
__TEST__
alpha
%% b %%
(+ c +)
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TAGS metatext -%]
[% a %]
%% b %%
<* c *>
__TEST__
[% a %]
bravo
<* c *>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TAGS template1 -%]
[% a %]
%% b %%
(+ c +)
__TEST__
alpha
bravo
(+ c +)
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TAGS html -%]
[% a %]
%% b %%
<!-- c -->
__TEST__
[% a %]
%% b %%
charlie
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TAGS asp -%]
[% a %]
%% b %%
<!-- c -->
<% d %>
<? e ?>
__TEST__
[% a %]
%% b %%
<!-- c -->
delta
<? e ?>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TAGS php -%]
[% a %]
%% b %%
<!-- c -->
<% d %>
<? e ?>
__TEST__
[% a %]
%% b %%
<!-- c -->
<% d %>
echo
__EXPECTED__

	#-----------------------------------------------------------------------
	# test processor with pre-defined TAG_STYLE
	#-----------------------------------------------------------------------
	# use htags
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TAGS ignored -%]
[% a %]
<!-- c -->
more stuff
__TEST__
[% TAGS ignored -%]
[% a %]
charlie
more stuff
__EXPECTED__

	#-----------------------------------------------------------------------
	# test processor with pre-defined START_TAG and END_TAG
	#-----------------------------------------------------------------------
	# use stags
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TAGS ignored -%]
<!-- also totally ignored and treated as text -->
[* a *]
blah [* b *] blah
__TEST__
[% TAGS ignored -%]
<!-- also totally ignored and treated as text -->
alpha
blah bravo blah
__EXPECTED__

	#-----------------------------------------------------------------------
	# XML style tags
	#-----------------------------------------------------------------------
	# use basic
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TAGS <tt: > -%]
<tt:a=10->
a: <tt:a>
<tt:FOR a = [ 1, 3, 5, 7 ]->
<tt:a>
<tt:END->
__TEST__
a: 10
1
3
5
7
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TAGS star -%]
[* a = 10 -*]
a is [* a *]
__TEST__
a is 10
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% tags; flags %]
[* a = 10 -*]
a is [* a *]
__TEST__
my tagsmy flags
[* a = 10 -*]
a is [* a *]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
flags: [% flags | html %]
tags: [% tags | html %]
__TEST__
flags: my flags
tags: my tags
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
This is a text block "hello" 'hello' 1/3 1\4 <html> </html>
$ @ { } @{ } ${ } # ~ ' ! % *foo
$a ${b} $c
__TEST__
This is a text block "hello" 'hello' 1/3 1\4 <html> </html>
$ @ { } @{ } ${ } # ~ ' ! % *foo
$a ${b} $c
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
<table width=50%>&copy;
__TEST__
<table width=50%>&copy;
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% foo = 'Hello World' -%]
start
[%
#
# [% foo %]
#
#
-%]
end
__TEST__
start
end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
pre
[%
# [% PROCESS foo %]
-%]
mid
[% BLOCK foo; "This is foo"; END %]
__TEST__
pre
mid
__EXPECTED__

	# use interp
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
This is a text block "hello" 'hello' 1/3 1\4 <html> </html>
\$ @ { } @{ } \${ } # ~ ' ! % *foo
$a ${b} $c
__TEST__
This is a text block "hello" 'hello' 1/3 1\4 <html> </html>
$ @ { } @{ } ${ } # ~ ' ! % *foo
alpha bravo charlie
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
<table width=50%>&copy;
__TEST__
<table width=50%>&copy;
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% foo = 'Hello World' -%]
start
[%
#
# [% foo %]
#
#
-%]
end
__TEST__
start
end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
pre
[%
#
# [% PROCESS foo %]
#
-%]
mid
[% BLOCK foo; "This is foo"; END %]
__TEST__
pre
mid
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = "C'est un test"; a %]
__TEST__
C'est un test
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META title = "C'est un test" -%]
[% component.title -%]
__TEST__
C'est un test
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META title = 'C\'est un autre test' -%]
[% component.title -%]
__TEST__
C'est un autre test
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% META title = "C'est un \"test\"" -%]
[% component.title -%]
__TEST__
C'est un "test"
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% sfoo %]/[% sbar %]
__TEST__
foo/bar
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  s1 = "$sfoo"
    s2 = "$sbar ";
    s3  = sfoo;
    ref(s1);
    '/';
    ref(s2);
    '/';
    ref(s3);
-%]
__TEST__
foo[]/bar []/foo[Stringy]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% me = 'I' -%]
[% TRY -%]
   [%- THROW chicken "Failed failed failed" 'boo' name='Fred' -%]
[% CATCH -%]
ERROR: [% error.type %] - [% error.info.0 %]/[% error.info.1 %]/[% error.info.name %]
[% END %]
__TEST__
ERROR: chicken - Failed failed failed/boo/Fred
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY -%]
[% THROW food 'eggs' -%]
[% CATCH -%]
ERROR: [% error.type %] / [% error.info %]
[% END %]
__TEST__
ERROR: food / eggs
__EXPECTED__

	# test throwing multiple params
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% pi = 3.14
   e  = 2.718 -%]
[% TRY -%]
[% THROW foo pi e msg="fell over" reason="brain exploded" -%]
[% CATCH -%]
[% error.type %]: pi=[% error.info.0 %]  e=[% error.info.1 %]
     I [% error.info.msg %] because my [% error.info.reason %]!
[% END %]
__TEST__
foo: pi=3.14  e=2.718
     I fell over because my brain exploded!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY -%]
[% THROW foo 'one' 2 three=3.14 -%]
[% CATCH -%]
   [% error.type %]
   [% error.info.0 %]
   [% error.info.1 %]
   [% error.info.three %]
   [%- FOREACH e = error.info.args %]
   * [% e %]
   [%- END %]
[% END %]
__TEST__
   foo
   one
   2
   3.14
   * one
   * 2
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY -%]
[% THROW food 'eggs' 'flour' msg="Missing Ingredients" -%]
[% CATCH food -%]
   [% error.info.msg %]
[% FOREACH item = error.info.args -%]
      * [% item %]
[% END -%]
[% END %]
__TEST__
   Missing Ingredients
      * eggs
      * flour
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash.a %]
__TEST__
FETCH:alpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash.b %]
__TEST__
FETCH:bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
ready
set:[% hash.c = 'cosmos' %]
go:[% hash.c %]
__TEST__
ready
set:
go:FETCH:STORE:cosmos
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash.foo.bar = 'one' -%]
[% hash.foo.bar %]
__TEST__
one
__EXPECTED__

	# list tests
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list.0 %]
__TEST__
FETCH:10
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list.first %]-[% list.last %]
__TEST__
FETCH:10-FETCH:30
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list.push(40); list.last %]
__TEST__
FETCH:40
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list.4 = 50; list.4 %]
__TEST__
FETCH:STORE:50
__EXPECTED__

	#-----------------------------------------------------------------------
	# now try using the XS stash
	#-----------------------------------------------------------------------

	# hash tests
	# use xs
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash.a %]
__TEST__
FETCH:alpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash.b %]
__TEST__
FETCH:bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash.c = 'crazy'; hash.c %]
__TEST__
FETCH:STORE:crazy
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% DEFAULT hash.c = 'more crazy'; hash.c %]
__TEST__
FETCH:STORE:crazy
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash.wiz = 'woz' -%]
[% hash.wiz %]
__TEST__
FETCH:STORE:woz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% DEFAULT hash.zero = 'nothing';
   hash.zero
%]
__TEST__
FETCH:STORE:nothing
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before: [% hash.one %]
after: [% DEFAULT hash.one = 'solitude';
   hash.one
%]
__TEST__
before: FETCH:1
after: FETCH:1
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash.foo = 10; hash.foo = 20; hash.foo %]
__TEST__
FETCH:STORE:20
__EXPECTED__

	# this test should create an intermediate hash
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% DEFAULT hash.person = { };
   hash.person.name  = 'Arthur Dent';
   hash.person.email = 'dent@tt2.org'; 
-%]
name:  [% hash.person.name %]
email: [% hash.person.email %]
__TEST__
name:  Arthur Dent
email: dent@tt2.org
__EXPECTED__

	# list tests
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list.0 %]
__TEST__
FETCH:10
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list.first %]-[% list.last %]
__TEST__
FETCH:10-FETCH:STORE:50
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list.push(60); list.last %]
__TEST__
FETCH:60
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list.5 = 70; list.5 %]
__TEST__
FETCH:STORE:70
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% DEFAULT list.5 = 80; list.5 %]
__TEST__
FETCH:STORE:70
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% list.10 = 100; list.10 %]
__TEST__
FETCH:STORE:100
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% stuff = [ ];
   stuff.0 = 'some stuff';
   stuff.0
-%]
__TEST__
some stuff
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% THROW foxtrot %]
[% CATCH %]
[[% error.type%]] [% error.info %]
[% END %]
__TEST__
[undef] foxtrot
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% THROW $f %]
[% CATCH %]
[[% error.type%]] [% error.info %]
[% END %]
__TEST__
[undef] foxtrot
__EXPECTED__

	#-----------------------------------------------------------------------
	# throw simple types
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before try
[% TRY %]
try this
[% THROW barf "Feeling sick" %]
don't try this
[% CATCH barf %]
caught barf: [% error.info +%]
[% END %]
after try
__TEST__
before try
try this
caught barf: Feeling sick
after try
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
some content
[% THROW up 'more malaise' %]
afterthought
[% CATCH barf %]
no barf
[% CATCH up %]
caught up: [% error.info +%]
[% CATCH %]
no default
[% END %]
after
__TEST__
before
some content
caught up: more malaise
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
some content
[% THROW up b %]
afterthought
[% CATCH barf %]
no barf
[% CATCH up %]
caught up: [% error.info +%]
[% CATCH %]
no default
[% END %]
after
__TEST__
before
some content
caught up: bravo
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
some content
[% THROW $a b %]
afterthought
[% CATCH barf %]
no barf
[% CATCH up %]
caught up: [% error.info +%]
[% CATCH alpha %]
caught up: [% error.info +%]
[% CATCH %]
no default
[% END %]
after
__TEST__
before
some content
caught up: bravo
after
__EXPECTED__

	#-----------------------------------------------------------------------
	# throw complex (hierarchical) exception types
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
some content
[% THROW alpha.bravo c %]
afterthought
[% CATCH alpha.charlie %]
WRONG: [% error.info +%]
[% CATCH alpha.bravo %]
RIGHT: [% error.info +%]
[% CATCH alpha %]
WRONG: [% error.info +%]
[% CATCH %]
WRONG: [% error.info +%]
[% END %]
after
__TEST__
before
some content
RIGHT: charlie
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
some content
[% THROW alpha.bravo c %]
afterthought
[% CATCH delta.charlie %]
WRONG: [% error.info +%]
[% CATCH delta.bravo %]
WRONG: [% error.info +%]
[% CATCH alpha %]
RIGHT: [% error.info +%]
[% CATCH %]
WRONG: [% error.info +%]
[% END %]
after
__TEST__
before
some content
RIGHT: charlie
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
some content
[% THROW "alpha.$b" c %]
afterthought
[% CATCH delta.charlie %]
WRONG: [% error.info +%]
[% CATCH alpha.bravo %]
RIGHT: [% error.info +%]
[% CATCH alpha.charlie %]
WRONG: [% error.info +%]
[% CATCH %]
WRONG: [% error.info +%]
[% END %]
after
__TEST__
before
some content
RIGHT: charlie
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
some content
[% THROW alpha.bravo c %]
afterthought
[% CATCH delta.charlie %]
WRONG: [% error.info +%]
[% CATCH delta.bravo %]
WRONG: [% error.info +%]
[% CATCH alpha.charlie %]
WRONG: [% error.info +%]
[% CATCH %]
RIGHT: [% error.info +%]
[% END %]
after
__TEST__
before
some content
RIGHT: charlie
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
some content
[% THROW alpha.bravo.charlie d %]
afterthought
[% CATCH alpha.bravo.charlie %]
RIGHT: [% error.info +%]
[% CATCH alpha.bravo %]
WRONG: [% error.info +%]
[% CATCH alpha %]
WRONG: [% error.info +%]
[% CATCH %]
WRONG: [% error.info +%]
[% END %]
after
__TEST__
before
some content
RIGHT: delta
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
some content
[% THROW alpha.bravo.charlie d %]
afterthought
[% CATCH alpha.bravo.foxtrot %]
WRONG: [% error.info +%]
[% CATCH alpha.bravo %]
RIGHT: [% error.info +%]
[% CATCH alpha %]
WRONG: [% error.info +%]
[% CATCH %]
WRONG: [% error.info +%]
[% END %]
after
__TEST__
before
some content
RIGHT: delta
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
some content
[% THROW alpha.bravo.charlie d %]
afterthought
[% CATCH alpha.bravo.foxtrot %]
WRONG: [% error.info +%]
[% CATCH alpha.echo %]
WRONG: [% error.info +%]
[% CATCH alpha %]
RIGHT: [% error.info +%]
[% CATCH %]
WRONG: [% error.info +%]
[% END %]
after
__TEST__
before
some content
RIGHT: delta
after
__EXPECTED__

	#-----------------------------------------------------------------------
	# test FINAL block
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
foo
[% CATCH %]
bar
[% FINAL %]
baz
[% END %]
__TEST__
foo
baz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
foo
[% THROW anything %]
[% CATCH %]
bar
[% FINAL %]
baz
[% END %]
__TEST__
foo
bar
baz
__EXPECTED__

	#-----------------------------------------------------------------------
	# use CLEAR to clear output from TRY block
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
foo
[% THROW anything %]
[% CATCH %]
[% CLEAR %]
bar
[% FINAL %]
baz
[% END %]
__TEST__
before
bar
baz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
foo
[% CATCH %]
bar
[% FINAL %]
[% CLEAR %]
baz
[% END %]
__TEST__
before
baz
__EXPECTED__

	#-----------------------------------------------------------------------
	# nested TRY blocks
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
outer
[% TRY %]
inner
[% THROW foo g %]
more inner
[% CATCH %]
caught inner
[% END %]
more outer
[% CATCH %]
caught outer
[% END %]
after
__TEST__
before
outer
inner
caught inner
more outer
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
outer
[% TRY %]
inner
[% THROW foo g %]
more inner
[% CATCH foo %]
caught inner foo
[% CATCH %]
caught inner
[% END %]
more outer
[% CATCH foo %]
caught outer
[% END %]
after
__TEST__
before
outer
inner
caught inner foo
more outer
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
outer
[% TRY %]
inner
[% THROW foo g %]
more inner
[% CATCH foo %]
caught inner foo
[% THROW $error %]
[% CATCH %]
caught inner
[% END %]
more outer
[% CATCH foo %]
caught outer foo [% error.info +%]
[% CATCH %]
caught outer [[% error.type %]] [% error.info +%]
[% END %]
after
__TEST__
before
outer
inner
caught inner foo
caught outer foo golf
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
outer
[% TRY %]
inner
[% THROW foo g %]
more inner
[% CATCH foo %]
caught inner foo
[% THROW bar error.info %]
[% CATCH %]
caught inner
[% END %]
more outer
[% CATCH foo %]
WRONG: caught outer foo [% error.info +%]
[% CATCH bar %]
RIGHT: caught outer bar [% error.info +%]
[% CATCH %]
caught outer [[% error.type %]] [% error.info +%]
[% END %]
after
__TEST__
before
outer
inner
caught inner foo
RIGHT: caught outer bar golf
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
outer
[% TRY %]
inner
[% THROW foo g %]
more inner
[% CATCH foo %]
[% CLEAR %]
caught inner foo
[% THROW bar error.info %]
[% CATCH %]
caught inner
[% END %]
more outer
[% CATCH foo %]
WRONG: caught outer foo [% error.info +%]
[% CATCH bar %]
RIGHT: caught outer bar [% error.info +%]
[% CATCH %]
caught outer [[% error.type %]] [% error.info +%]
[% END %]
after
__TEST__
before
outer
caught inner foo
RIGHT: caught outer bar golf
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
outer
[% TRY %]
inner
[% THROW foo g %]
more inner
[% CATCH foo %]
caught inner foo
[% THROW bar error.info %]
[% CATCH %]
caught inner
[% END %]
more outer
[% CATCH foo %]
WRONG: caught outer foo [% error.info +%]
[% CATCH bar %]
[% CLEAR %]
RIGHT: caught outer bar [% error.info +%]
[% CATCH %]
caught outer [[% error.type %]] [% error.info +%]
[% END %]
after
__TEST__
before
RIGHT: caught outer bar golf
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% TRY %]
outer
[% TRY %]
inner
[% THROW foo g %]
more inner
[% CATCH bar %]
caught inner bar
[% END %]
more outer
[% CATCH foo %]
RIGHT: caught outer foo [% error.info +%]
[% CATCH bar %]
WRONG: caught outer bar [% error.info +%]
[% CATCH %]
caught outer [[% error.type %]] [% error.info +%]
[% END %]
after
__TEST__
before
outer
inner
RIGHT: caught outer foo golf
after
__EXPECTED__

	#-----------------------------------------------------------------------
	# test throwing from Perl code via die()
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
before
[% throw_egg %]
after
[% CATCH egg %]
caught egg: [% error.info +%]
[% END %]
after
__TEST__
before
caught egg: scrambled
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
before
[% throw_any %]
after
[% CATCH egg %]
caught egg: [% error.info +%]
[% CATCH %]
caught any: [[% error.type %]] [% error.info %]
[% END %]
after
__TEST__
before
caught any: [undef] undefined error
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% THROW up 'feeling sick' %]
[% CATCH %]
[% error %]
[% END %]
__TEST__
up error - feeling sick
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% THROW up 'feeling sick' %]
[% CATCH %]
[% e %]
[% END %]
__TEST__
up error - feeling sick
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY; THROW food 'cabbage'; CATCH DEFAULT; "caught $e.info"; END %]
__TEST__
caught cabbage
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  TRY; 
	THROW food 'cabbage'; 
     CATCH food; 
	"caught food: $e.info\n";
     CATCH DEFAULT;
	"caught default: $e.info";
     END
 %]
__TEST__
caught food: cabbage
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY;
     PROCESS no_such_file;
   CATCH;
     "error: $error\n";
   END;
%]
__TEST__
error: file error - no_such_file: not found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE url -%]
loaded
[% url %]
[% url('foo') %]
[% url(foo='bar') %]
[% url('bar', wiz='woz') %]
__TEST__
loaded

foo
foo=bar
bar?wiz=woz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE url('here') -%]
[% url %]
[% url('there') %]
[% url(any='where') %]
[% url('every', which='way') %]
[% sorted( url('every', which='way', you='can') ) %]
__TEST__
here
there
here?any=where
every?which=way
every?which=way&amp;you=can
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE url('there', name='fred') -%]
[% url %]
[% url(name='tom') %]
[% sorted( url(age=24) ) %]
[% sorted( url(age=42, name='frank') ) %]
__TEST__
there?name=fred
there?name=tom
there?age=24&amp;name=fred
there?age=42&amp;name=frank
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE url('/cgi-bin/woz.pl') -%]
[% url(name="Elrich von Benjy d'Weiro") %]
__TEST__
/cgi-bin/woz.pl?name=Elrich%20von%20Benjy%20d%27Weiro
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE url '/script' { one => 1, two => [ 2, 4 ], three => [ 3, 6, 9] } -%]
[% url  %]
__TEST__
/script?one=1&amp;three=3&amp;three=6&amp;three=9&amp;two=2&amp;two=4
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% url.product.view %]
[% url.product.view(style='compact') %]
__TEST__
/product
/product?style=compact
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% url.product.add %]
[% url.product.add(style='compact') %]
__TEST__
/product?action=add
/product?action=add&amp;style=compact
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% url.product.edit %]
[% url.product.edit(style='compact') %]
__TEST__
/product?action=edit&amp;style=editor
/product?action=edit&amp;style=compact
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% CALL no_escape -%]
[% url.product.edit %]
[% url.product.edit(style='compact') %]
__TEST__
/product?action=edit&style=editor
/product?action=edit&style=compact
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE url('/cgi-bin/woz.pl') -%]
[% url(utf8="NaÃ¯ve Unicode") %]
__TEST__
/cgi-bin/woz.pl?utf8=Na%C3%AFve%20Unicode
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[[% nosuchvariable %]]
[$nosuchvariable]
__TEST__
[]
[]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
[% GET b %]
[% get c %]
__TEST__
alpha
bravo
charlie
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% b %] [% GET b %]
__TEST__
bravo bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
$a $b ${c} ${d} [% e %]
__TEST__
alpha bravo charlie delta echo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% letteralpha %]
[% ${"letter$a"} %]
[% GET ${"letter$a"} %]
__TEST__
'alpha'
'alpha'
'alpha'
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f.g %] [% f.$gee %] [% f.${gee} %]
__TEST__
golf golf golf
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% GET f.h %] [% get f.h %] [% f.${'h'} %] [% get f.${'h'} %]
__TEST__
hotel hotel hotel hotel
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
$f.h ${f.g} ${f.h}.gif
__TEST__
hotel golf hotel.gif
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f.i.j %] [% GET f.i.j %] [% get f.i.k %]
__TEST__
juliet juliet kilo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f.i.j %] $f.i.k [% f.${'i'}.${"j"} %] ${f.i.k}.gif
__TEST__
juliet kilo juliet kilo.gif
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% 'this is literal text' %]
[% GET 'so is this' %]
[% "this is interpolated text containing $r and $f.i.j" %]
[% GET "$t?" %]
[% "<a href=\"${f.i.k}.html\">$f.i.k</a>" %]
__TEST__
this is literal text
so is this
this is interpolated text containing romeo and juliet
tango?
<a href="kilo.html">kilo</a>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% name = "$a $b $w" -%]
Name: $name
__TEST__
Name: alpha bravo whisky
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% join('--', a b, c, f.i.j) %]
__TEST__
alpha--bravo--charlie--juliet
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% text = 'The cat sat on the mat' -%]
[% FOREACH word = split(' ', text) -%]<$word> [% END %]
__TEST__
<The> <cat> <sat> <on> <the> <mat> 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% magic.chant %] [% GET magic.chant %]
[% magic.chant('foo') %] [% GET magic.chant('foo') %]
__TEST__
Hocus Pocus Hocus Pocus
Hocus Pocus Hocus Pocus
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
<<[% magic.spell %]>>
[% magic.spell(a b c) %]
__TEST__
<<>>
alpha and a bit of bravo and a bit of charlie
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% one %] [% one('two', 'three') %] [% one(2 3) %]
__TEST__
one one one
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% day.prev %]
[% day.this %]
[% belief('yesterday') %]
__TEST__
All my troubles seemed so far away...
Now it looks as though they're here to stay.
Oh I believe in yesterday.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Yesterday, $day.prev
$day.this
${belief('yesterday')}
__TEST__
Yesterday, All my troubles seemed so far away...
Now it looks as though they're here to stay.
Oh I believe in yesterday.
__EXPECTED__

	# use notcase
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% day.next %]
$day.next
__TEST__
Monday
Tuesday
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH [ 1 2 3 4 5 ] %]$day.next [% END %]
__TEST__
Wednesday Thursday Friday Saturday Sunday 
__EXPECTED__

	# use default
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% halt %]
after
__TEST__
before
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH k = yankee -%]
[% loop.count %]. [% IF k; k.a; ELSE %]undef[% END %]
[% END %]
__TEST__
1. undef
2. 1
3. undef
4. 2
__EXPECTED__

	#-----------------------------------------------------------------------
	# CALL 
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before [% CALL a %]a[% CALL b %]n[% CALL c %]d[% CALL d %] after
__TEST__
before and after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
..[% CALL undef %]..
__TEST__
....
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
..[% CALL zero %]..
__TEST__
....
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
..[% n %]..[% CALL n %]..
__TEST__
..0....
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
..[% up %]..[% CALL up %]..[% n %]
__TEST__
..1....2
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% CALL reset %][% n %]
__TEST__
0
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% CALL reset(100) %][% n %]
__TEST__
100
__EXPECTED__

	#-----------------------------------------------------------------------
	# SET 
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = a %] $a
[% a = b %] $a
__TEST__
 alpha
 bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% SET a = a %] $a
[% SET a = b %] $a
[% SET a = $c %] [$a]
[% SET a = $gee %] $a
[% SET a = ${gee} %] $a
__TEST__
 alpha
 bravo
 []
 solo golf
 solo golf
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = b
   b = c
   c = d
   d = e
%][% a %] [% b %] [% c %] [% d %]
__TEST__
bravo charlie delta echo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% SET
   a = c
   b = d
   c = e
%]$a $b $c
__TEST__
charlie delta echo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% 'a' = d
   'include' = e
   'INCLUDE' = f.g
%][% a %]-[% ${'include'} %]-[% ${'INCLUDE'} %]
__TEST__
delta-echo-golf
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = f.g %] $a
[% a = f.i.j %] $a
__TEST__
 golf
 juliet
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f.g = r %] $f.g
[% f.i.j = s %] $f.i.j
[% f.i.k = f.i.j %] ${f.i.k}
__TEST__
 romeo
 sierra
 sierra
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% user = {
    id = 'abw'
    name = 'Andy Wardley'
    callsign = "[-$a-$b-$w-]"
   }
-%]
${user.id} ${ user.id } $user.id ${user.id}.gif
[% message = "$b: ${ user.name } (${user.id}) ${ user.callsign }" -%]
MSG: $message
__TEST__
abw abw abw abw.gif
MSG: bravo: Andy Wardley (abw) [-alpha-bravo-whisky-]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% product = {
     id   => 'XYZ-2000',
     desc => 'Bogon Generator',
     cost => 678,
   }
-%]
The $product.id $product.desc costs \$${product.cost}.00
__TEST__
The XYZ-2000 Bogon Generator costs $678.00
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% data => {
       g => 'my data'
   }
   complex = {
       gee => 'g'
   }
-%]
[% data.${complex.gee} %]
__TEST__
my data
__EXPECTED__

	#-----------------------------------------------------------------------
	# DEFAULT
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
[% DEFAULT a = b -%]
[% a %]
__TEST__
alpha
alpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = '' -%]
[% DEFAULT a = b -%]
[% a %]
__TEST__
bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = ''   b = '' -%]
[% DEFAULT 
   a = c
   b = d
   z = r
-%]
[% a %] [% b %] [% z %]
__TEST__
charlie delta romeo
__EXPECTED__

	#-----------------------------------------------------------------------
	# 'global' vars
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.version = '3.14' -%]
Version: [% global.version %]
__TEST__
Version: 3.14
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Version: [% global.version %]
__TEST__
Version: 3.14
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.newversion = global.version + 1 -%]
Version: [% global.version %]
Version: [% global.newversion %]
__TEST__
Version: 3.14
Version: 4.14
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Version: [% global.version %]
Version: [% global.newversion %]
__TEST__
Version: 3.14
Version: 4.14
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% hash1 = {
      foo => 'Foo',
      bar => 'Bar',
   }
   hash2 = {
      wiz => 'Wiz',
      woz => 'Woz',
   }
-%]
[% hash1.import(hash2) -%]
keys: [% hash1.keys.sort.join(', ') %]
__TEST__
keys: bar, foo, wiz, woz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% mage = { name    =>    'Gandalf', 
        aliases =>  [ 'Mithrandir', 'Olorin', 'Incanus' ] }
-%]
[% import(mage) -%]
[% name %]
[% aliases.join(', ') %]
__TEST__
Gandalf
Mithrandir, Olorin, Incanus
__EXPECTED__

	# test private variables
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[[% _private %]][[% _hidden %]]
__TEST__
[][]
__EXPECTED__

	# make them visible
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% CALL expose -%]
[[% _private %]][[% _hidden %]]
__TEST__
[123][456]
__EXPECTED__

	# Stas reported a problem with spacing in expressions but I can't
	# seem to reproduce it...
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = 4 -%]
[% b=6 -%]
[% c = a + b -%]
[% d=a+b -%]
[% c %]/[% d %]
__TEST__
10/10
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = 1
   b = 2
   c = 3
-%]
[% d = 1+1 %]d: [% d %]
[% e = a+b %]e: [% e %]
__TEST__
d: 2
e: 3
__EXPECTED__

	# these tests check that the incorrect precedence in the parser has now
	# been fixed, thanks to Craig Barrat.
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  1 || 0 && 0  # should be 1 || (0&&0), not (1||0)&&0 %]
__TEST__
1
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  1 + !0 + 1  # should be 1 + (!0) + 0, not 1 + !(0 + 1) %]
__TEST__
3
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "x" _ "y" == "y"; ','  # should be ("x"_"y")=="y", not "x"_("y"=="y") %]
__TEST__
,
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% "x" _ "y" == "xy"      # should be ("x"_"y")=="xy", not "x"_("y"=="xy") %]
__TEST__
1
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% add(3, 5) %]
__TEST__
8
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% add(3 + 4, 5 + 7) %]
__TEST__
19
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = 10;
   b = 20;
   c = 30;
   add(add(a,b+1),c*3);
%]
__TEST__
121
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = 10;
   b = 20;
   c = 30;
   d = 5;
   e = 7;
   add(a+5, b < 10 ? c : d + e*5);
-%]
__TEST__
55
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% SET monkey="testing" IF 1; monkey %]
__TEST__
testing
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
[% $a %]
[% GET b %]
[% GET $b %]
[% get c %]
[% get $c %]
__TEST__
alpha
alpha
bravo
bravo
charlie
charlie
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% b %] [% $b %] [% GET b %] [% GET $b %]
__TEST__
bravo bravo bravo bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
$a $b ${c} ${d} [% $e %]
__TEST__
alpha bravo charlie delta echo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% letteralpha %]
[% ${"letter$a"} %]
[% GET ${"letter$a"} %]
__TEST__
'alpha'
'alpha'
'alpha'
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f.g %] [% $f.g %] [% $f.$g %]
__TEST__
golf golf golf
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% GET f.h %] [% get $f.h %] [% get f.${'h'} %] [% get $f.${'h'} %]
__TEST__
hotel hotel hotel hotel
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
$f.h ${f.g} ${f.h}.gif
__TEST__
hotel golf hotel.gif
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f.i.j %] [% $f.i.j %] [% f.$i.j %] [% f.i.$j %] [% $f.$i.$j %]
__TEST__
juliet juliet juliet juliet juliet
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f.i.j %] [% $f.i.j %] [% GET f.i.j %] [% GET $f.i.j %]
__TEST__
juliet juliet juliet juliet
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% get $f.i.k %]
__TEST__
kilo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f.i.j %] $f.i.k [% f.${'i'}.${"j"} %] ${f.i.k}.gif
__TEST__
juliet kilo juliet kilo.gif
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% 'this is literal text' %]
[% GET 'so is this' %]
[% "this is interpolated text containing $r and $f.i.j" %]
[% GET "$t?" %]
[% "<a href=\"${f.i.k}.html\">$f.i.k</a>" %]
__TEST__
this is literal text
so is this
this is interpolated text containing romeo and juliet
tango?
<a href="kilo.html">kilo</a>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% name = "$a $b $w" -%]
Name: $name
__TEST__
Name: alpha bravo whisky
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% join('--', a b, c, f.i.j) %]
__TEST__
alpha--bravo--charlie--juliet
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% text = 'The cat sat on the mat' -%]
[% FOREACH word = split(' ', text) -%]<$word> [% END %]
__TEST__
<The> <cat> <sat> <on> <the> <mat> 
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% magic.chant %] [% GET magic.chant %]
[% magic.chant('foo') %] [% GET $magic.chant('foo') %]
__TEST__
Hocus Pocus Hocus Pocus
Hocus Pocus Hocus Pocus
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
<<[% magic.spell %]>>
[% magic.spell(a b c) %]
__TEST__
<<>>
alpha and a bit of bravo and a bit of charlie
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% one %] [% one('two', 'three') %] [% one(2 3) %]
__TEST__
one one one
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% day.prev %]
[% day.this %]
[% belief('yesterday') %]
__TEST__
All my troubles seemed so far away...
Now it looks as though they're here to stay.
Oh I believe in yesterday.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Yesterday, $day.prev
$day.this
${belief('yesterday')}
__TEST__
Yesterday, All my troubles seemed so far away...
Now it looks as though they're here to stay.
Oh I believe in yesterday.
__EXPECTED__

	# use notcase
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% day.next %]
$day.next
__TEST__
Monday
Tuesday
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FOREACH [ 1 2 3 4 5 ] %]$day.next [% END %]
__TEST__
Wednesday Thursday Friday Saturday Sunday 
__EXPECTED__

	# use default
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% halt %]
after
__TEST__
before
__EXPECTED__

	#-----------------------------------------------------------------------
	# CALL 
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before [% CALL a %]a[% CALL b %]n[% CALL c %]d[% CALL d %] after
__TEST__
before and after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
..[% CALL undef %]..
__TEST__
....
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
..[% CALL zero %]..
__TEST__
....
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
..[% n %]..[% CALL n %]..
__TEST__
..0....
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
..[% up %]..[% CALL up %]..[% n %]
__TEST__
..1....2
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% CALL reset %][% n %]
__TEST__
0
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% CALL reset(100) %][% n %]
__TEST__
100
__EXPECTED__

	#-----------------------------------------------------------------------
	# SET 
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = a %] $a
[% a = b %] $a
[% a = $c %] $a
[% $a = d %] $a
[% $a = $e %] $a
__TEST__
 alpha
 bravo
 charlie
 delta
 echo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__]; 
[% SET a = a %] $a
[% SET a = b %] $a
[% SET a = $c %] $a
[% SET $a = d %] $a
[% SET $a = $e %] $a
__TEST__
 alpha
 bravo
 charlie
 delta
 echo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = b
   b = c
   c = d
   d = e
%][% a %] [% b %] [% c %] [% d %]
__TEST__
bravo charlie delta echo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% SET
   a = c
   b = d
   c = e
%]$a $b $c
__TEST__
charlie delta echo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = f.g %] $a
[% a = $f.h %] $a
[% a = f.i.j %] $a
[% a = $f.i.k %] $a
__TEST__
 golf
 hotel
 juliet
 kilo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% f.g = r %] $f.g
[% $f.h = $r %] $f.h
[% f.i.j = $s %] $f.i.j
[% $f.i.k = f.i.j %] ${f.i.k}
__TEST__
 romeo
 romeo
 sierra
 sierra
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% user = {
    id = 'abw'
    name = 'Andy Wardley'
    callsign = "[-$a-$b-$w-]"
   }
-%]
${user.id} ${ user.id } $user.id ${user.id}.gif
[% message = "$b: ${ user.name } (${user.id}) ${ user.callsign }" -%]
MSG: $message
__TEST__
abw abw abw abw.gif
MSG: bravo: Andy Wardley (abw) [-alpha-bravo-whisky-]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% product = {
     id   => 'XYZ-2000',
     desc => 'Bogon Generator',
     cost => 678,
   }
-%]
The $product.id $product.desc costs \$${product.cost}.00
__TEST__
The XYZ-2000 Bogon Generator costs $678.00
__EXPECTED__

	#-----------------------------------------------------------------------
	# DEFAULT
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a %]
[% DEFAULT a = b -%]
[% a %]
__TEST__
alpha
alpha
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = '' -%]
[% DEFAULT a = b -%]
[% a %]
__TEST__
bravo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% a = ''   b = '' -%]
[% DEFAULT 
   a = c
   b = d
   z = r
-%]
[% a %] [% b %] [% z %]
__TEST__
charlie delta romeo
__EXPECTED__

	#-----------------------------------------------------------------------
	# 'global' vars
	#-----------------------------------------------------------------------
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.version = '3.14' -%]
Version: [% global.version %]
__TEST__
Version: 3.14
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Version: [% global.version %]
__TEST__
Version: 3.14
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% global.newversion = global.version + 1 -%]
Version: [% global.version %]
Version: [% global.newversion %]
__TEST__
Version: 3.14
Version: 4.14
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Version: [% global.version %]
Version: [% global.newversion %]
__TEST__
Version: 3.14
Version: 4.14
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name pre-defined bottom view --
[% BLOCK bottom/list; "BOTTOM LIST: "; item.join(', '); END;
   list = [10, 20 30];
   bottom.print(list)
%]
__TEST__
BOTTOM LIST: 10, 20, 30
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name pre-defined middle view --
[% BLOCK bottom/list; "BOTTOM LIST: "; item.join(', '); END;
   BLOCK middle/hash; "MIDDLE HASH: "; item.values.nsort.join(', '); END;
   list = [10, 20 30];
   hash = { pi => 3.142, e => 2.718 };
   middle.print(list); "\n";
   middle.print(hash); "\n";
%]
__TEST__
BOTTOM LIST: 10, 20, 30
MIDDLE HASH: 2.718, 3.142
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE v = View -%]
[[% v.prefix %]]
__TEST__
[]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE v = View( map => { default="any" } ) -%]
[[% v.map.default %]]
__TEST__
[any]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view( prefix=> 'foo/', suffix => '.tt2') -%]
[[% view.prefix %]bar[% view.suffix %]]
[[% view.template_name('baz') %]]
__TEST__
[foo/bar.tt2]
[foo/baz.tt2]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view( prefix=> 'foo/', suffix => '.tt2') -%]
[[% view.prefix %]bar[% view.suffix %]]
[[% view.template_name('baz') %]]
__TEST__
[foo/bar.tt2]
[foo/baz.tt2]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view -%]
[% view.print('Hello World') %]
[% BLOCK text %]TEXT: [% item %][% END -%]
__TEST__
TEXT: Hello World
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view -%]
[% view.print( { foo => 'bar' } ) %]
[% BLOCK hash %]HASH: {
[% FOREACH key = item.keys.sort -%]
   [% key %] => [% item.$key %]
[%- END %]
}
[% END -%]
__TEST__
HASH: {
   foo => bar
}
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view -%]
[% view = view.clone( prefix => 'my_' ) -%]
[% view.view('hash', { bar => 'baz' }) %]
[% BLOCK my_hash %]HASH: {
[% FOREACH key = item.keys.sort -%]
   [% key %] => [% item.$key %]
[%- END %]
}
[% END -%]
__TEST__
HASH: {
   bar => baz
}
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view(prefix='my_') -%]
[% view.print( foo => 'wiz', bar => 'waz' ) %]
[% BLOCK my_hash %]KEYS: [% item.keys.sort.join(', ') %][% END %]
__TEST__
KEYS: bar, foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view -%]
[% view.print( view ) %]
[% BLOCK Template_View %]Printing a Template::View object[% END -%]
__TEST__
Printing a Template::View object
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view(prefix='my_') -%]
[% view.print( view ) %]
[% view.print( view, prefix='your_' ) %]
[% BLOCK my_Template_View %]Printing my Template::View object[% END -%]
[% BLOCK your_Template_View %]Printing your Template::View object[% END -%]
__TEST__
Printing my Template::View object
Printing your Template::View object
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view(prefix='my_', notfound='any' ) -%]
[% view.print( view ) %]
[% view.print( view, prefix='your_' ) %]
[% BLOCK my_any %]Printing any of my objects[% END -%]
[% BLOCK your_any %]Printing any of your objects[% END -%]
__TEST__
Printing any of my objects
Printing any of your objects
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view(prefix => 'my_', map => { default => 'catchall' } ) -%]
[% view.print( view ) %]
[% view.print( view, default="catchsome" ) %]
[% BLOCK my_catchall %]Catching all defaults[% END -%]
[% BLOCK my_catchsome %]Catching some defaults[% END -%]
__TEST__
Catching all defaults
Catching some defaults
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view(prefix => 'my_', map => { default => 'catchnone' } ) -%]
[% view.default %]
[% view.default = 'catchall' -%]
[% view.default %]
[% view.print( view ) %]
[% view.print( view, default="catchsome" ) %]
[% BLOCK my_catchall %]Catching all defaults[% END -%]
[% BLOCK my_catchsome %]Catching some defaults[% END -%]
__TEST__
catchnone
catchall
Catching all defaults
Catching some defaults
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view(prefix='my_', default='catchall' notfound='lost') -%]
[% view.print( view ) %]
[% BLOCK my_lost %]Something has been found[% END -%]
__TEST__
Something has been found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view -%]
[% TRY ;
     view.print( view ) ;
   CATCH view ;
     "[$error.type] $error.info" ;
   END
%]
__TEST__
[view] file error - Template_View: not found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view -%]
[% view.print( foo ) %]
__TEST__
{ e => 2.718, pi => 3.14 }
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view -%]
[% view.print( foo, method => 'reverse' ) %]
__TEST__
{ pi => 3.14, e => 2.718 }
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view(prefix='my_', include_naked=0, view_naked=1) -%]
[% BLOCK my_foo; "Foo: $item"; END -%]
[[% view.view_foo(20) %]]
[[% view.foo(30) %]]
__TEST__
[Foo: 20]
[Foo: 30]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view(prefix='my_', include_naked=0, view_naked=0) -%]
[% BLOCK my_foo; "Foo: $item"; END -%]
[[% view.view_foo(20) %]]
[% TRY ;
     view.foo(30) ;
   CATCH ;
     error.info ;
   END
%]
__TEST__
[Foo: 20]
no such view member: foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view(map => { HASH => 'my_hash', ARRAY => 'your_list' }) -%]
[% BLOCK text %]TEXT: [% item %][% END -%]
[% BLOCK my_hash %]HASH: [% item.keys.sort.join(', ') %][% END -%]
[% BLOCK your_list %]LIST: [% item.join(', ') %][% END -%]
[% view.print("some text") %]
[% view.print({ alpha => 'a', bravo => 'b' }) %]
[% view.print([ 'charlie', 'delta' ]) %]
__TEST__
TEXT: some text
HASH: alpha, bravo
LIST: charlie, delta
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view(item => 'thing',
	    map => { HASH => 'my_hash', ARRAY => 'your_list' }) -%]
[% BLOCK text %]TEXT: [% thing %][% END -%]
[% BLOCK my_hash %]HASH: [% thing.keys.sort.join(', ') %][% END -%]
[% BLOCK your_list %]LIST: [% thing.join(', ') %][% END -%]
[% view.print("some text") %]
[% view.print({ alpha => 'a', bravo => 'b' }) %]
[% view.print([ 'charlie', 'delta' ]) %]
__TEST__
TEXT: some text
HASH: alpha, bravo
LIST: charlie, delta
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view -%]
[% view.print('Hello World') %]
[% view1 = view.clone( prefix='my_') -%]
[% view1.print('Hello World') %]
[% view2 = view1.clone( prefix='dud_', notfound='no_text' ) -%]
[% view2.print('Hello World') %]
[% BLOCK text %]TEXT: [% item %][% END -%]
[% BLOCK my_text %]MY TEXT: [% item %][% END -%]
[% BLOCK dud_no_text %]NO TEXT: [% item %][% END -%]
__TEST__
TEXT: Hello World
MY TEXT: Hello World
NO TEXT: Hello World
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view( prefix = 'base_', default => 'any' ) -%]
[% view1 = view.clone( prefix => 'one_') -%]
[% view2 = view.clone( prefix => 'two_') -%]
[% view.default %] / [% view.map.default %]
[% view1.default = 'anyone' -%]
[% view1.default %] / [% view1.map.default %]
[% view2.map.default = 'anytwo' -%]
[% view2.default %] / [% view2.map.default %]
[% view.print("Hello World") %] / [% view.print(blessed_list) %]
[% view1.print("Hello World") %] / [% view1.print(blessed_list) %]
[% view2.print("Hello World") %] / [% view2.print(blessed_list) %]
[% BLOCK base_text %]ANY TEXT: [% item %][% END -%]
[% BLOCK one_text %]ONE TEXT: [% item %][% END -%]
[% BLOCK two_text %]TWO TEXT: [% item %][% END -%]
[% BLOCK base_any %]BASE ANY: [% item.as_list.join(', ') %][% END -%]
[% BLOCK one_anyone %]ONE ANY: [% item.as_list.join(', ') %][% END -%]
[% BLOCK two_anytwo %]TWO ANY: [% item.as_list.join(', ') %][% END -%]
__TEST__
any / any
anyone / anyone
anytwo / anytwo
ANY TEXT: Hello World / BASE ANY: Hello, World
ONE TEXT: Hello World / ONE ANY: Hello, World
TWO TEXT: Hello World / TWO ANY: Hello, World
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view( prefix => 'my_', item => 'thing' ) -%]
[% view.view('thingy', [ 'foo', 'bar'] ) %]
[% BLOCK my_thingy %]thingy: [ [% thing.join(', ') %] ][%END %]
__TEST__
thingy: [ foo, bar ]
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view -%]
[% view.map.${'Template::View'} = 'myview' -%]
[% view.print(view) %]
[% BLOCK myview %]MYVIEW[% END%]
__TEST__
MYVIEW
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view -%]
[% view.include('greeting', msg => 'Hello World!') %]
[% BLOCK greeting %]msg: [% msg %][% END -%]
__TEST__
msg: Hello World!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view( prefix="my_" )-%]
[% view.include('greeting', msg => 'Hello World!') %]
[% BLOCK my_greeting %]msg: [% msg %][% END -%]
__TEST__
msg: Hello World!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view( prefix="my_" )-%]
[% view.include_greeting( msg => 'Hello World!') %]
[% BLOCK my_greeting %]msg: [% msg %][% END -%]
__TEST__
msg: Hello World!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view( prefix="my_" )-%]
[% INCLUDE $view.template('greeting')
   msg = 'Hello World!' %]
[% BLOCK my_greeting %]msg: [% msg %][% END -%]
__TEST__
msg: Hello World!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view( title="My View" )-%]
[% view.title %]
__TEST__
My View
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE view( title="My View" )-%]
[% newview = view.clone( col = 'Chartreuse') -%]
[% newerview = newview.clone( title => 'New Title' ) -%]
[% view.title %]
[% newview.title %]
[% newview.col %]
[% newerview.title %]
[% newerview.col %]
__TEST__
My View
My View
Chartreuse
New Title
Chartreuse
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW fred prefix='blat_' %]
This is the view
[% END -%]
[% BLOCK blat_foo; 'This is blat_foo'; END -%]
[% fred.view_foo %]
__TEST__
This is blat_foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW fred %]
This is the view
[% view.prefix = 'blat_' %]
[% END -%]
[% BLOCK blat_foo; 'This is blat_foo'; END -%]
[% fred.view_foo %]
__TEST__
This is blat_foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW fred %]
This is the view
[% view.prefix = 'blat_' %]
[% view.thingy = 'bloop' %]
[% fred.name = 'Freddy' %]
[% END -%]
[% fred.prefix %]
[% fred.thingy %]
[% fred.name %]
__TEST__
blat_
bloop
Freddy
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW fred prefix='blat_'; view.name='Fred'; END -%]
[% fred.prefix %]
[% fred.name %]
[% TRY;
     fred.prefix = 'nonblat_';
   CATCH;
     error;
   END
%]
[% TRY;
     fred.name = 'Derek';
   CATCH;
     error;
   END
%]
__TEST__
blat_
Fred
view error - cannot update config item in sealed view: prefix
view error - cannot update item in sealed view: name
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW foo prefix='blat_' default="default" notfound="notfound"
     title="fred" age=23 height=1.82 %]
[% view.other = 'another' %]
[% END -%]
[% BLOCK blat_hash -%]
[% FOREACH key = item.keys.sort -%]
   [% key %] => [% item.$key %]
[% END -%]
[% END -%]
[% foo.print(foo.data) %]
__TEST__
   age => 23
   height => 1.82
   other => another
   title => fred
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW foo %]
[% BLOCK hello -%]
Hello World!
[% END %]
[% BLOCK goodbye -%]
Goodbye World!
[% END %]
[% END -%]
[% TRY; INCLUDE foo; CATCH; error; END %]
[% foo.include_hello %]
__TEST__
file error - foo: not found
Hello World!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% title = "Previous Title" -%]
[% VIEW foo 
     include_naked = 1
     title = title or 'Default Title'
     copy  = 'me, now'
-%]

[% view.bgcol = '#ffffff' -%]

[% BLOCK header -%]
Header:  bgcol: [% view.bgcol %]
         title: [% title %]
    view.title: [% view.title %]
[%- END %]

[% BLOCK footer -%]
&copy; Copyright [% view.copy %]
[%- END %]

[% END -%]
[% title = 'New Title' -%]
[% foo.header %]
[% foo.header(bgcol='#dead' title="Title Parameter") %]
[% foo.footer %]
[% foo.footer(copy="you, then") %]
__TEST__
Header:  bgcol: #ffffff
         title: New Title
    view.title: Previous Title
Header:  bgcol: #ffffff
         title: Title Parameter
    view.title: Previous Title
&copy; Copyright me, now
&copy; Copyright me, now
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW foo 
    title  = 'My View' 
    author = 'Andy Wardley'
    bgcol  = bgcol or '#ffffff'
-%]
[% view.arg1 = 'argument #1' -%]
[% view.data.arg2 = 'argument #2' -%]
[% END -%]
 [% foo.title %]
 [% foo.author %]
 [% foo.bgcol %]
 [% foo.arg1 %]
 [% foo.arg2 %]
[% bar = foo.clone( title='New View', arg1='New Arg1' ) %]cloned!
 [% bar.title %]
 [% bar.author %]
 [% bar.bgcol %]
 [% bar.arg1 %]
 [% bar.arg2 %]
originals:
 [% foo.title %]
 [% foo.arg1 %]
__TEST__
 My View
 Andy Wardley
 #ffffff
 argument #1
 argument #2
cloned!
 New View
 Andy Wardley
 #ffffff
 New Arg1
 argument #2
originals:
 My View
 argument #1
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW basic title = "My Web Site" %]
  [% BLOCK header -%]
  This is the basic header: [% title or view.title %]
  [%- END -%]
[% END -%]

[%- VIEW fancy 
      title = "<fancy>$basic.title</fancy>"
      basic = basic 
%]
  [% BLOCK header ; view.basic.header(title = title or view.title) %]
  Fancy new part of header
  [%- END %]
[% END -%]
===
[% basic.header %]
[% basic.header( title = "New Title" ) %]
===
[% fancy.header %]
[% fancy.header( title = "Fancy Title" ) %]
__TEST__
===
  This is the basic header: My Web Site
  This is the basic header: New Title
===
  This is the basic header: <fancy>My Web Site</fancy>
  Fancy new part of header
  This is the basic header: Fancy Title
  Fancy new part of header
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW baz  notfound='lost' %]
[% BLOCK lost; 'lost, not found'; END %]
[% END -%]
[% baz.any %]
__TEST__
lost, not found
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW woz  prefix='outer_' %]
[% BLOCK wiz; 'The inner wiz'; END %]
[% END -%]
[% BLOCK outer_waz; 'The outer waz'; END -%]
[% woz.wiz %]
[% woz.waz %]
__TEST__
The inner wiz
The outer waz
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW foo %]

   [% BLOCK file -%]
      File: [% item.name %]
   [%- END -%]

   [% BLOCK directory -%]
      Dir: [% item.name %]
   [%- END %]

[% END -%]
[% foo.view_file({ name => 'some_file' }) %]
[% foo.include_file(item => { name => 'some_file' }) %]
[% foo.view('directory', { name => 'some_dir' }) %]
__TEST__
      File: some_file
      File: some_file
      Dir: some_dir
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK parent -%]
This is the base block
[%- END -%]
[% VIEW super %]
   [%- BLOCK parent -%]
   [%- INCLUDE parent | replace('base', 'super') -%]
   [%- END -%]
[% END -%]
base: [% INCLUDE parent %]
super: [% super.parent %]
__TEST__
base: This is the base block
super: This is the super block
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK foo -%]
public foo block
[%- END -%]
[% VIEW plain %]
   [% BLOCK foo -%]
<plain>[% PROCESS foo %]</plain>
   [%- END %]
[% END -%]
[% VIEW fancy %]
   [% BLOCK foo -%]
   [%- plain.foo | replace('plain', 'fancy') -%]
   [%- END %]
[% END -%]
[% plain.foo %]
[% fancy.foo %]
__TEST__
<plain>public foo block</plain>
<fancy>public foo block</fancy>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW foo %]
[% BLOCK Blessed_List -%]
This is a list: [% item.as_list.join(', ') %]
[% END -%]
[% END -%]
[% foo.print(blessed_list) %]
__TEST__
This is a list: Hello, World
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW my.foo value=33; END -%]
n: [% my.foo.value %]
__TEST__
n: 33
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW parent -%]
[% BLOCK one %]This is base one[% END %]
[% BLOCK two %]This is base two[% END %]
[% END -%]

[%- VIEW child1 base=parent %]
[% BLOCK one %]This is child1 one[% END %]
[% END -%]

[%- VIEW child2 base=parent %]
[% BLOCK two %]This is child2 two[% END %]
[% END -%]

[%- VIEW child3 base=child2 %]
[% BLOCK two %]This is child3 two[% END %]
[% END -%]

[%- FOREACH child = [ child1, child2, child3 ] -%]
one: [% child.one %]
[% END -%]
[% FOREACH child = [ child1, child2, child3 ] -%]
two: [% child.two %]
[% END %]
__TEST__
one: This is child1 one
one: This is base one
one: This is base one
two: This is base two
two: This is child2 two
two: This is child3 two
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW my.view.default
        prefix = 'view/default/'
        value  = 3.14;
   END
-%]
value: [% my.view.default.value %]
__TEST__
value: 3.14
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW my.view.default
        prefix = 'view/default/'
        value  = 3.14;
   END;
   VIEW my.view.one
        base   = my.view.default
        prefix = 'view/one/';
   END;
   VIEW my.view.two
	base  = my.view.default
        value = 2.718;
   END;
-%]
[% BLOCK view/default/foo %]Default foo[% END -%]
[% BLOCK view/one/foo %]One foo[% END -%]
0: [% my.view.default.foo %]
1: [% my.view.one.foo %]
2: [% my.view.two.foo %]
0: [% my.view.default.value %]
1: [% my.view.one.value %]
2: [% my.view.two.value %]
__TEST__
0: Default foo
1: One foo
2: Default foo
0: 3.14
1: 3.14
2: 2.718
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW foo number = 10 sealed = 0; END -%]
a: [% foo.number %]
b: [% foo.number = 20 %]
c: [% foo.number %]
d: [% foo.number(30) %]
e: [% foo.number %]
__TEST__
a: 10
b: 
c: 20
d: 30
e: 30
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% VIEW foo number = 10 silent = 1; END -%]
a: [% foo.number %]
b: [% foo.number = 20 %]
c: [% foo.number %]
d: [% foo.number(30) %]
e: [% foo.number %]
__TEST__
a: 10
b: 
c: 10
d: 10
e: 10
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
-- name bad base --
[%  TRY; 
        VIEW wiz base=no_such_base_at_all; 
        END;
    CATCH;
        error;
    END
-%]
__TEST__
view error - Invalid base specified for view
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
before
[% WHILE bollocks %]
do nothing
[% END %]
after
__TEST__
before
after
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
Commence countdown...
[% a = 10 %]
[% WHILE a %]
[% a %]..[% a = dec(a) %]
[% END +%]
The end
__TEST__
Commence countdown...
10..9..8..7..6..5..4..3..2..1..
The end
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% reset %]
[% WHILE (item = next) %]
item: [% item +%]
[% END %]
__TEST__
Reset list
item: x-ray
item: yankee
item: zulu
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% reset %]
[% WHILE (item = next) %]
item: [% item +%]
[% BREAK IF item == 'yankee' %]
[% END %]
Finis
__TEST__
Reset list
item: x-ray
item: yankee
Finis
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% reset %]
[% "* $item\n" WHILE (item = next) %]
__TEST__
Reset list
* x-ray
* yankee
* zulu
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% TRY %]
[% WHILE true %].[% END %]
[% CATCH +%]
error: [% error.info %]
[% END %]
__TEST__
...................................................................................................
error: WHILE loop terminated (> 100 iterations)
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% reset %]
[% WHILE (item = next) %]
[% NEXT IF item == 'yankee' -%]
* [% item +%]
[% END %]
__TEST__
Reset list
* x-ray
* zulu
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%  
    i = 1;
    WHILE i <= 10;
        SWITCH i;
        CASE 5;
            i = i + 1;
            NEXT;
        CASE 8;
            LAST;
        END;
        "$i\n";
        i = i + 1;
    END;
-%]
__TEST__
1
2
3
4
6
7
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%
    i = 1;
    WHILE i <= 10;
        IF 1;
            IF i == 5; i = i + 1; NEXT; END;
            IF i == 8; LAST; END;
        END;
        "$i\n";
        i = i + 1;
    END;
-%]
__TEST__
1
2
3
4
6
7
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%
    i = 1;
    WHILE i <= 4;
        j = 1;
        WHILE j <= 4;
            k = 1;
            SWITCH j;
            CASE 2;
                WHILE k == 1; LAST; END;
            CASE 3;
                IF j == 3; j = j + 1; NEXT; END;
            END;
            "$i,$j,$k\n";
            j = j + 1;
        END;
        i = i + 1;
    END;
-%]
__TEST__
1,1,1
1,2,1
1,4,1
2,1,1
2,2,1
2,4,1
3,1,1
3,2,1
3,4,1
4,1,1
4,2,1
4,4,1
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%
    k = 1;
    LAST WHILE k == 1;
    "$k\n";
-%]
__TEST__
1
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK mypage %]
This is the header
[% content %]
This is the footer
[% END -%]
[% WRAPPER mypage -%]
This is the content
[%- END %]
__TEST__
This is the header
This is the content
This is the footer
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% WRAPPER mywrap
   title = 'Another Test' -%]
This is some more content
[%- END %]
__TEST__
Wrapper Header
Title: Another Test
This is some more content
Wrapper Footer
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% WRAPPER mywrap
   title = 'Another Test' -%]
This is some content
[%- END %]
__TEST__
Wrapper Header
Title: Another Test
This is some content
Wrapper Footer
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% WRAPPER page
   title = 'My Interesting Page'
%]
[% WRAPPER section
   title = 'Quantum Mechanics'
-%]
Quantum mechanics is a very interesting subject wish 
should prove easy for the layman to fully comprehend.
[%- END %]

[% WRAPPER section
   title = 'Desktop Nuclear Fusion for under $50'
-%]
This describes a simple device which generates significant 
sustainable electrical power from common tap water by process 
of nuclear fusion.
[%- END %]
[% END %]

[% BLOCK page -%]
<h1>[% title %]</h1>
[% content %]
<hr>
[% END %]

[% BLOCK section -%]
<p>
<h2>[% title %]</h2>
[% content %]
</p>
[% END %]
__TEST__
<h1>My Interesting Page</h1>

<p>
<h2>Quantum Mechanics</h2>
Quantum mechanics is a very interesting subject wish 
should prove easy for the layman to fully comprehend.
</p>

<p>
<h2>Desktop Nuclear Fusion for under $50</h2>
This describes a simple device which generates significant 
sustainable electrical power from common tap water by process 
of nuclear fusion.
</p>

<hr>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[%# FOREACH s = [ 'one' 'two' ]; WRAPPER section; PROCESS $s; END; END %]
[% PROCESS $s WRAPPER section FOREACH s = [ 'one' 'two' ] %]
[% BLOCK one; title = 'Block One' %]This is one[% END %]
[% BLOCK two; title = 'Block Two' %]This is two[% END %]
[% BLOCK section %]
<h1>[% title %]</h1>
<p>
[% content %]
</p>
[% END %]
__TEST__
<h1>Block One</h1>
<p>
This is one
</p><h1>Block Two</h1>
<p>
This is two
</p>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK one; title = 'Block One' %]This is one[% END %]
[% BLOCK section %]
<h1>[% title %]</h1>
<p>
[% content %]
</p>
[% END %]
[% WRAPPER section -%]
[% PROCESS one %]
[%- END %]
title: [% title %]
__TEST__
<h1>Block One</h1>
<p>
This is one
</p>
title: Block One
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% title = "foo" %]
[% WRAPPER outer title="bar" -%]
The title is [% title %]
[%- END -%]
[% BLOCK outer -%]
outer [[% title %]]: [% content %]
[%- END %]
__TEST__
outer [bar]: The title is foo
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK a; "<a>$content</a>"; END; 
   BLOCK b; "<b>$content</b>"; END;
   BLOCK c; "<c>$content</c>"; END;
   WRAPPER a + b + c; 'FOO'; END;
%]
__TEST__
<a><b><c>FOO</c></b></a>
__EXPECTED__

	# This next text demonstrates a limitation in the parser
	# http://tt2.org/pipermail/templates/2006-January/008197.html
	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% BLOCK a; "<a>$content</a>"; END; 
   BLOCK b; "<b>$content</b>"; END;
   BLOCK c; "<c>$content</c>"; END;
   A='a'; 
   B='b';
   C='c';
   WRAPPER $A + $B + $C; 'BAR'; END;
%]
__TEST__
<a><b><c>BAR</c></b></a>
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE Wrap -%]
[% text = BLOCK -%]
This is a long block of text that goes on for a long long time and then carries on some more after that, it's very interesting, NOT!
[%- END -%]
[% text = BLOCK; text FILTER replace('\s+', ' '); END -%]
[% Wrap(text, 25,) %]
__TEST__
This is a long block of
text that goes on for a
long long time and then
carries on some more
after that, it's very
interesting, NOT!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER wrap -%]
This is a long block of text that goes on for a long long time and then carries on some more after that, it's very interesting, NOT!
[% END %]
__TEST__
This is a long block of text that goes on for a long long time and then
carries on some more after that, it's very interesting, NOT!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE wrap -%]
[% FILTER wrap(25) -%]
This is a long block of text that goes on for a long long time and then carries on some more after that, it's very interesting, NOT!
[% END %]
__TEST__
This is a long block of
text that goes on for a
long long time and then
carries on some more
after that, it's very
interesting, NOT!
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% FILTER wrap(10, '> ', '+ ') -%]
The cat sat on the mat and then sat on the flat.
[%- END %]
__TEST__
> The cat
+ sat on
+ the mat
+ and
+ then
+ sat on
+ the
+ flat.
__EXPECTED__

	is-valid $tt._process( q:to[__TEST__] ), q:to[__EXPECTED__];
[% USE wrap -%]
[% FILTER bullet = wrap(40, '* ', '  ') -%]
First, attach the transmutex multiplier to the cross-wired quantum
homogeniser.
[%- END %]
[% FILTER remove('\s+(?=\n)') -%]
[% FILTER bullet -%]
Then remodulate the shield to match the harmonic frequency, taking 
care to correct the phase difference.
[% END %]
[% END %]
__TEST__
* First, attach the transmutex
  multiplier to the cross-wired quantum
  homogeniser.
* Then remodulate the shield to match
  the harmonic frequency, taking
  care to correct the phase difference.
__EXPECTED__
)
}, Q{all-tests};

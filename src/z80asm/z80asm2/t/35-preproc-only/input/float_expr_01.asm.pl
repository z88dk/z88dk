#!/usr/bin/env perl

use Modern::Perl;
use Math::Trig;

my @fdata = (
     0.0,   1.0,     -1.0,     255.0,   -255.0,   256.0,
    -256.0, 65535.0, -65535.0, 65536.0, -65536.0, 5.5,
    -5.5,   5.5e1,   5.0e-1
);

check_float_expr(1);
check_float_expr("pi");
check_float_expr("e");
check_float_expr("1+.5");
check_float_expr("1-.5");
check_float_expr("1+-.5");
check_float_expr("2*4");
check_float_expr("2/4");
check_float_expr("2*-4");
check_float_expr("2**8");
check_float_expr("4**3**2");
check_float_expr("(4**3)**2");
check_float_expr("4**(0.5)");
check_float_expr("+4");
check_float_expr("+ +4");
check_float_expr("+ + -4");
check_float_expr("+ + - +4");
check_float_expr("2+3*4");
check_float_expr("(2+3)*4");
check_float_expr("2*3+4");
check_float_expr("2*(3+4)");

for my $func (qw(sin cos tan sinh cosh tanh)) {
    check_float_expr("$func(0.5)");
    check_float_expr("a$func($func(0.5))");
}

check_float_expr("atan2(0.5,0.5)");
check_float_expr("log(2.7)");
check_float_expr("log2(2.5)");
check_float_expr("log10(15)");
check_float_expr("exp(2)");
check_float_expr("exp2(2)");
check_float_expr("pow(2,4)");
check_float_expr("sqrt(4)");
check_float_expr("cbrt(8)");
check_float_expr("ceil(2.5)");
check_float_expr("ceil(-2.5)");
check_float_expr("floor(2.5)");
check_float_expr("floor(-2.5)");
check_float_expr("trunc(2.5)");
check_float_expr("trunc(-2.5)");
check_float_expr("abs(2.5)");
check_float_expr("abs(-2.5)");
check_float_expr("hypot(2,3)");
check_float_expr("fmod(10,3)");
check_float_expr("fmod(10,-3)");
check_float_expr("fmod(-10,3)");
check_float_expr("fmod(-10,-3)");

for ( -8 .. 24 ) {
    check_float_expr( 2**$_ );
}

for ( 0.1, 0.2, 1 / 3 ) {
    check_float_expr($_);
}

for my $f (@fdata) {
    check_float_expr($f);
}

# output .asm code
sub check_float_expr {
    my ($expr) = @_;

    # compute expression value
    my $value = eval $expr;
    die "Error evaluating expression '$expr': $@" if $@;

    # output the expression and its value as .asm code
    say "defm \"--------\"";
    say "defm \"$expr = $value\"";
    say "float $expr";
    say "defm \"--------\"";
    say "float $value";
}

sub e     { return exp(1); }
sub log2  { return log( $_[0] ) / log(2); }
sub log10 { return log( $_[0] ) / log(10); }
sub exp2  { return 2**$_[0]; }
sub pow   { return $_[0]**$_[1]; }
sub cbrt  { return $_[0]**( 1 / 3 ); }
sub ceil  { return int( $_[0] ) + ( $_[0] > int( $_[0] ) ? 1 : 0 ); }
sub floor { return int( $_[0] ) - ( $_[0] < int( $_[0] ) ? 1 : 0 ); }
sub trunc { return int( $_[0] ); }
sub hypot { return sqrt( $_[0]**2 + $_[1]**2 ); }
sub fmod  { return $_[0] - $_[1] * int( $_[0] / $_[1] ); }


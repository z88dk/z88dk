#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/3222
# zsdcc -debug: the C_LINE of a line does not end in the whitespace sdcc
# writes before its '==', so z88dk-ticks can read the line number of a map
# location

unlink_testfiles;

# -------------------------------------------------------------------------
# the "Transform C line" rule, in both copies

spew( "${test}.in", "\tC\$f.c\$5\$1_0\$7\t==.\n", "\tC\$f.c\$6\$1_0\$7 ==.\n", "\tC\$f.c\$7\$2_0\$8==.\n", "\tC\$f.c\$8\$2_0\$9\t= .\n" );
for my $rules ( "../../lib/sdcc/sdcc_opt.1", "../../lib/xcc_rules.1" ) {
    capture_ok( "z88dk-copt $rules < ${test}.in", <<'END' );
C_LINE 5,"f.c::x::10000::7"
C_LINE 6,"f.c::x::10000::7"
C_LINE 7,"f.c::x::20000::8"
C_LINE 8,"f.c::x::20000::9"
END
}

# -------------------------------------------------------------------------
# a map built by zcc, and a z88dk-ticks stop in it

spew( "${test}.c", <<END );
int a, b;
void f(void)
{
    a = 1;
    b = 2;
    a = 3;
}
int main(void)
{
    f();
    return 0;
}
END

run_ok("zcc +test -compiler=sdcc -debug -m ${test}.c -o ${test}.bin");

my ( $bad, %at );
for my $line ( path("${test}.map")->lines ) {
    next unless $line =~ /^__C_LINE_(\d+)_(\S+)\s+=\s+\$([0-9A-F]+)\s*;(.*)/;
    my ( $n, $label, $addr, $rest ) = ( $1, $2, $3, $4 );
    $bad++ if $label =~ /_09$/ || $rest =~ /\t:\d+\s*$/;
    push @{ $at{$addr} }, $n;
}
ok !$bad, "no C_LINE of the map ends in whitespace";

# a line that is alone at its address
my ($addr6) = grep { "@{$at{$_}}" eq "6" } keys %at;
ok defined $addr6, "line 6 has an address of its own" or die;

path("${test}.cmd")->spew("break 0x$addr6\ncont\nbt\nquit\n");
run_ok("z88dk-ticks -x ${test}.map -d ${test}.bin < ${test}.cmd > ${test}.out 2>&1");
like slurp("${test}.out"), qr/^\s*at \Q${test}\E\.c:6\r?$/m, "z88dk-ticks stops at line 6";

unlink_testfiles;
done_testing;

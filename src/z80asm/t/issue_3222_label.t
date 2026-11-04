#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/3222
# z88dk-ticks: the label of zsdcc inside a function (l_<function>_<nnnnn>)
# is not the function that contains an address

unlink_testfiles;

# -------------------------------------------------------------------------
# labels of the shape of zsdcc's, and runtime helpers that are not

spew( "${test}.asm", <<END );
		public	main
main:		nop			; 0
l_main_00104:	nop			; 1
l_gint:		nop			; 2
l_gint_1234:	nop			; 3
l_x_00104:	nop			; 4
l_00104:	nop			; 5
		ret			; 6
END
run_ok("z88dk-z80asm -b -m ${test}.asm");

path("${test}.cmd")->spew( join( "", map {"break $_\n"} 1 .. 5 ), "cont\n" x 5, "quit\n" );
run_ok("z88dk-ticks -x ${test}.map -d ${test}.bin < ${test}.cmd > ${test}.out 2>&1");
my $out = slurp("${test}.out");
like $out, qr/0001 \(main\+1\)>/,          "l_main_00104 is skipped";
like $out, qr/0002 \(l_gint\+0\)>/,        "l_gint is a symbol";
like $out, qr/0003 \(l_gint_1234\+0\)>/,   "l_gint_1234 has four digits";
like $out, qr/0004 \(l_gint_1234\+1\)>/,   "l_x_00104 is skipped";
like $out, qr/0005 \(l_00104\+0\)>/,       "l_00104 has no function name";

# -------------------------------------------------------------------------
# a breakpoint inside a loop of a zsdcc build is in function main

spew( "${test}.c", <<END );
int counter;
int main(void)
{
    int i;
    for (i = 0; i < 3; i++) {
        counter += i;
    }
    return counter;
}
END
run_ok("zcc +test -compiler=sdcc -debug -m ${test}.c -o ${test}.bin");

my ($addr) = map { /^(l_main_\d{5})\s+=\s+\$([0-9A-F]+)/ ? $2 : () } path("${test}.map")->lines;
ok defined $addr, "the loop has a label of zsdcc" or die;
path("${test}.cmd")->spew("break 0x$addr\ncont\nbt\nquit\n");
run_ok("z88dk-ticks -x ${test}.map -d ${test}.bin < ${test}.cmd > ${test}.out 2>&1");
$out = slurp("${test}.out");
like $out,   qr/\* function main\+\d+ /, "the frame is the function main";
unlike $out, qr/\* l_main_/,            "the frame is not the label";

unlink_testfiles;
done_testing;

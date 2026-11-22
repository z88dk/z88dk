#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/3254
# sccz80 -debug: a for statement opens a block of its own, so the variable
# declared in its header and the lines of its body have a block that holds them

unlink_testfiles;
spew( "${test}.c", <<END );
int g;
int f(int a)
{
    int t = a;
    if (a) {
        int p = t;
        t += p;
    }
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 2; j++)
            t += i + j;
    }
    return t;
}
int main(void) { g = f(1); return 0; }
END

run_ok("zcc +z80 -clib=new -debug -m ${test}.c -o ${test}.bin");

my @map = path("${test}.map")->lines;

# Records of the locals of f: name => "level/block"
my %local;
for my $line (@map) {
    next unless $line =~ /^__CDBINFO__(\S+)\s+=/;
    ( my $rec = $1 ) =~ s/_([0-9a-f]{2})/chr(hex($1))/ge;
    $local{$1} = "$2/$3" if $rec =~ /^S:L\Q${test}\E\.c\.f\$(\w+)\$(\d+)_0\$(\d+)\(/;
}
is_deeply \%local, {
    a => "0/0",
    t => "1/1",
    p => "2/2",     # the if block
    i => "2/3",     # the for block, one level below the function block
    j => "4/5",     # the inner for block, inside the body block 4
}, "locals of f: level/block";

# C_LINE annotations of lines 4..13 of f: "line level/block"
my @lines;
for my $line (@map) {
    next unless $line =~ /^__C_LINE_.* ; .*, \Q${test}\E\.c::f::(\d+)::(\d+):(\d+)$/;
    push @lines, [ $3, "$1/$2" ] if $3 >= 4 && $3 <= 13;
}
is_deeply [ map { "$_->[0] $_->[1]" } sort { $a->[0] <=> $b->[0] || $a->[1] cmp $b->[1] } @lines ], [
    "4 1/1", "5 1/1", "6 2/2", "7 2/2", "8 2/2",
    "9 1/1",        # the for line itself is still in the enclosing block
    "10 3/4",       # inside the for body block
    "11 4/5",       # inside the inner for block
    "12 3/4",
    "13 1/1",       # back in the enclosing block after the for
], "C_LINE level/block of lines 4..13 of f";

unlink_testfiles;
done_testing;

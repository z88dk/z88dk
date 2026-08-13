#!/usr/bin/env perl

# Issue 3008: +cpm writes the uninitialised BSS region into the flat .COM image.
#
# A CP/M program's BSS is zeroed at startup by the classic CRT
# (lib/crt/classic/crt_initialise_bss.inc: ld hl,__BSS_head / ... / ldir), so
# the BSS bytes need not be stored in the .COM.  On +cpm they nevertheless end
# up in the file: the flat image spans from $0100 to the end of BSS instead of
# stopping at __BSS_head, bloating every .COM by the size of its BSS.
#
# This testcase builds a +cpm program with a large uninitialised array and
# asserts the .COM holds only code+data (size == __BSS_head - $0100).  It is
# RED on current master; the assertion is wrapped in TODO so it documents the
# bug without turning CI red.  Remove the TODO once the .COM excludes BSS.

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use Path::Tiny;

my $dir = "${test}.dir";
path($dir)->remove_tree if -d $dir;
path($dir)->mkpath;

spew("$dir/prog.c", <<'END');
unsigned char buf[8000];
int main(void) { buf[0] = 1; return buf[0]; }
END

run_ok("zcc +cpm $dir/prog.c -o $dir/prog -create-app -m");

# appmake uppercases the output basename and appends .COM
my ($com) = grep { -f } ("$dir/PROG.COM", "$dir/prog.com");
ok defined($com), "found generated .COM";

my $map = slurp("$dir/prog.map");
my ($bss_head_hex) = $map =~ /^__BSS_head \s* = \s* \$ ([0-9A-Fa-f]+)/mx;
ok defined($bss_head_hex), "found __BSS_head in map";

my $code_data = hex($bss_head_hex) - 0x100;   # bytes from $0100 to __BSS_head
my $com_size  = -s $com;

# code+data end at __BSS_head; the trailing BSS is zeroed by the CRT and must
# not be materialised in the file.  RED on master -> TODO.
TODO: {
    local $TODO = "issue 3008: +cpm bundles uninitialised BSS into the .COM";
    ok $com_size <= $code_data,
       ".COM excludes BSS (size $com_size <= code+data $code_data)";
}

unlink_testfiles();
path($dir)->remove_tree;
done_testing();

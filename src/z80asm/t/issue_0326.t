#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/326
# z80asm: asm list files should be able to refer to their sources by relative path

my $dir = "${test}dir/my/deep/lib";
path($dir)->mkpath;

spew("$dir/lib.lst", <<END);
$dir/f1.asm
$dir/f2.o
$dir/f3
f4.asm
f5.o
f6
$dir/f7.asm
$dir/f8.o
$dir/f9
f10.asm
f11.o
f12
END

for my $id (1..12) {
	spew("$dir/f$id.asm", "defb $id\n");
	unlink "$dir/f$id.o"
}

# assemble 7..12, remove .asm keep .o to as if called from zcc
for my $id (7..12) {
	run_ok("z88dk-z80asm $dir/f$id.asm");
	ok -f "$dir/f$id.o", "$dir/f$id.o exists";
	ok unlink("$dir/f$id.asm"), "remove $dir/f$id.asm";
}

# link all
unlink_testfiles;
capture_ok("z88dk-z80asm -b -o${test}.bin ".quote_os("\@$dir/lib.lst"), "");
check_bin_file("${test}.bin", bytes(1..12));

# test file not found
ok unlink("$dir/f1.asm"), "remove $dir/f1.asm";
ok unlink("$dir/f1.o"),   "remove $dir/f1.o";

unlink_testfiles;
capture_nok("z88dk-z80asm -b -o${test}.bin ".quote_os("\@$dir/lib.lst"), <<END);
$dir/lib.lst:1: error: file open: $dir/f1.asm
  ^---- $dir/f1.asm
END

path("${test}dir")->remove_tree;
unlink_testfiles;
done_testing;


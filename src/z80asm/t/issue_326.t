#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/326
# z80asm: asm list files should be able to refer to their sources by relative path

use Modern::Perl;
use Test::More;
use Path::Tiny;
use Capture::Tiny::Extended 'capture';
require './t/test_utils.pl';

my $dir = 'test/my/deep/lib';

path($dir)->mkpath;

path($dir, 'lib.lst')->spew(<<END);
test/my/deep/lib/f1.asm
test/my/deep/lib/f2.o
test/my/deep/lib/f3
f4.asm
f5.o
f6
test/my/deep/lib/f7.asm
test/my/deep/lib/f8.o
test/my/deep/lib/f9
f10.asm
f11.o
f12
END

for my $id (1..12) {
	path($dir, "f$id.asm")->spew("defb $id\n");
	unlink "$dir/f$id.o"
}

# assemble 7..12, remove .asm keep .o to as if called from zcc
for my $id (7..12) {
	run("./z88dk-z80asm $dir/f$id.asm");
	ok -f "$dir/f$id.o", "$dir/f$id.o";
	ok unlink "$dir/f$id.asm", "$dir/f$id.asm";
}

# link all
unlink_testfiles();
run("./z88dk-z80asm -b -d -o=test.bin \"\@$dir/lib.lst\"");
t_binary(path("test.bin")->slurp_raw, pack("C*", 1..12));

# test file not found
ok unlink "$dir/f1.asm", "$dir/f1.asm";
ok unlink "$dir/f1.o",   "$dir/f1.o";

unlink_testfiles();
run("./z88dk-z80asm -b -d -o=test.bin \"\@$dir/lib.lst\"", 1, "", <<END);
test/my/deep/lib/lib.lst:1: error: file open: test/my/deep/lib/f1.asm
  ^---- test/my/deep/lib/f1.asm
END

path('test')->remove_tree;
done_testing;


sub run {
	my($cmd, $ret, $out, $err) = @_;
	ok 1, $cmd;
	my($stdout, $stderr, $return) = capture { system $cmd; };
	is_text( $stdout, ($out // ""), "stdout" );
	is_text( $stderr, ($err // ""), "stderr" );
	ok !!$return == !!($ret // 0), "exit value";
}


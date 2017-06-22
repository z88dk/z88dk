#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/233
# z80asm: z80asm ignores _map file if 0 bytes

use Modern::Perl;
use Test::More;
use Path::Tiny;
use Test::Differences;
use Data::HexDump;
use Capture::Tiny::Extended 'capture';
require 't/test_utils.pl';

path("map.asm")->spew(<<END);
	section s0
	org 0
	section s1
	section s2
	section s3
	section a0
	org 0x100
	section a1
	section b0
	org 0x200
	section b1
END

path("source.asm")->spew(<<END);
	section s0
	defb 0

	section s1
	defb 1

	section s2
	defb 2

	section s3
	defb 3

	section a0
	defb 10

	section a1
	defb 11

	section b0
	defb 20

	section b1
	defb 21
END

my $exp_map = <<'END';
__head                          = $0000 ; G 
__s0_head                       = $0000 ; G 
__a0_size                       = $0001 ; G 
__a1_size                       = $0001 ; G 
__b0_size                       = $0001 ; G 
__b1_size                       = $0001 ; G 
__s0_size                       = $0001 ; G 
__s0_tail                       = $0001 ; G 
__s1_head                       = $0001 ; G 
__s1_size                       = $0001 ; G 
__s2_size                       = $0001 ; G 
__s3_size                       = $0001 ; G 
__s1_tail                       = $0002 ; G 
__s2_head                       = $0002 ; G 
__s2_tail                       = $0003 ; G 
__s3_head                       = $0003 ; G 
__s3_tail                       = $0004 ; G 
__a0_head                       = $0100 ; G 
__a0_tail                       = $0101 ; G 
__a1_head                       = $0101 ; G 
__a1_tail                       = $0102 ; G 
__b0_head                       = $0200 ; G 
__b0_tail                       = $0201 ; G 
__b1_head                       = $0201 ; G 
__b1_tail                       = $0202 ; G 
__size                          = $0202 ; G 
__tail                          = $0202 ; G 
END

my $exp_bin = <<'END';
          00 01 02 03 04 05 06 07 - 08 09 0A 0B 0C 0D 0E 0F  0123456789ABCDEF

00000000  00 01 02 03 FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000010  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000020  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000030  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000040  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000050  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000060  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000070  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000080  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000090  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000000A0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000000B0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000000C0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000000D0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000000E0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000000F0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000100  0A 0B FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000110  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000120  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000130  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000140  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000150  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000160  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000170  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000180  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000190  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000001A0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000001B0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000001C0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000001D0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000001E0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
000001F0  FF FF FF FF FF FF FF FF - FF FF FF FF FF FF FF FF  ................
00000200  14 15                                              ..
END

unlink_tests();
run("./z80asm -b -o=test -m map.asm source.asm");
t_binary(path("test_s0.bin")->slurp_raw, pack("C*", 0, 1, 2, 3));
t_binary(path("test_a0.bin")->slurp_raw, pack("C*", 10, 11));
t_binary(path("test_b0.bin")->slurp_raw, pack("C*", 20, 21));
eq_or_diff scalar(path("map.map")->slurp), $exp_map, "mapfile contents";

run("appmake +glue -b test -c map --clean", "Creating test__.bin (org 0x0000 = 0)\n");
eq_or_diff HexDump(scalar(path("test__.bin")->slurp_raw)), $exp_bin, "binary contents";


unlink_tests();
run("./z80asm map.asm source.asm");
run("./z80asm -b -o=test -m map.o source.o");
t_binary(path("test_s0.bin")->slurp_raw, pack("C*", 0, 1, 2, 3));
t_binary(path("test_a0.bin")->slurp_raw, pack("C*", 10, 11));
t_binary(path("test_b0.bin")->slurp_raw, pack("C*", 20, 21));

eq_or_diff scalar(path("map.map")->slurp), $exp_map, "mapfile contents";

run("appmake +glue -b test -c map --clean", "Creating test__.bin (org 0x0000 = 0)\n");
eq_or_diff HexDump(scalar(path("test__.bin")->slurp_raw)), $exp_bin, "binary contents";

unlink_tests("map.asm", "source.asm");

done_testing;

sub run {
	my($cmd, $out, $err) = @_;
	ok 1, $cmd;
	my($stdout, $stderr, $return) = capture { system $cmd; };
	is $stdout, ($out // ""), "stdout";
	is $stderr, ($err // ""), "stderr";
	ok $return == 0, "exit value";
}

sub unlink_tests {
	unlink_testfiles("map.o", "map.map", "source.o", @_);
}

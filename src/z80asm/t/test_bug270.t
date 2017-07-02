#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/270
# z80asm: ignoring org -1 for sections when data is in object file separate from memory map file

use Modern::Perl;
use Test::More;
use Path::Tiny;
use Test::Differences;
use Data::HexDump;
use Capture::Tiny::Extended 'capture';
require './t/test_utils.pl';

my $test1_asm = <<END;
	SECTION CODE
	org 0

	SECTION DATA
	org 0x8000

	SECTION BSS
	org -1
END

my $test2_asm = <<END;
	SECTION CODE
	defb 1,2,3,4,5

	SECTION DATA
	defb 10,11,12,13

	SECTION BSS
	defs 3
END

my $exp_map = <<'END';
__CODE_head                     = $0000 ; G
__head                          = $0000 ; G
__BSS_size                      = $0003 ; G
__DATA_size                     = $0004 ; G
__CODE_size                     = $0005 ; G
__CODE_tail                     = $0005 ; G
__DATA_head                     = $8000 ; G
__BSS_head                      = $8004 ; G
__DATA_tail                     = $8004 ; G
__BSS_tail                      = $8007 ; G
__size                          = $8007 ; G
__tail                          = $8007 ; G
END

unlink_testfiles();
path("test1.asm")->spew($test1_asm);
path("test2.asm")->spew($test2_asm);
run("./z80asm -b -o=test -m test1.asm test2.asm");
t_binary(path("test_CODE.bin")->slurp_raw, pack("C*", 1, 2, 3, 4, 5));
t_binary(path("test_DATA.bin")->slurp_raw, pack("C*", 10, 11, 12, 13));
t_binary(path("test_BSS.bin")->slurp_raw, pack("C*", 0, 0, 0));
eq_or_diff scalar(path("test1.map")->slurp), $exp_map, "mapfile contents";

unlink_testfiles();
path("test1.asm")->spew($test1_asm);
path("test2.asm")->spew($test2_asm);
run("./z80asm test1.asm");
run("./z80asm test2.asm");
run("./z80asm -b -o=test -m test1.o test2.o");
t_binary(path("test_CODE.bin")->slurp_raw, pack("C*", 1, 2, 3, 4, 5));
t_binary(path("test_DATA.bin")->slurp_raw, pack("C*", 10, 11, 12, 13));
t_binary(path("test_BSS.bin")->slurp_raw, pack("C*", 0, 0, 0));
eq_or_diff scalar(path("test1.map")->slurp), $exp_map, "mapfile contents";

sub run {
	my($cmd, $out, $err) = @_;
	ok 1, $cmd;
	my($stdout, $stderr, $return) = capture { system $cmd; };
	is $stdout, ($out // ""), "stdout";
	is $stderr, ($err // ""), "stderr";
	ok $return == 0, "exit value";
}

done_testing;

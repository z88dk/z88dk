#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Test https://github.com/z88dk/z88dk/issues/233
# z80asm: force the name of the output file to use section names with defined ORG

use Modern::Perl;
use Test::More;
use Path::Tiny;
use Capture::Tiny::Extended 'capture';
require './t/test_utils.pl';

unlink_testfiles();
path("test.asm")->spew(<<END);
	section code
	org 0x100
	ld hl, (var)
	ret
	
	section data
	org 0x4000
	
	section user_data
var: defw 0x1234
END

my $cmd = "./z88dk-z80asm -l -b test.asm";
ok 1, $cmd;
my($stdout, $stderr, $return) = capture { system $cmd; };
is $stdout, "", "stdout";
is $stderr, "", "stderr";
ok $return == 0, "exit value";

ok -f "test_code.bin", "test_code.bin";
t_binary(path("test_code.bin")->slurp_raw, "\x2A\x00\x40\xC9", "test_code.bin contents");

ok -f "test_data.bin", "test_data.bin";
t_binary(path("test_data.bin")->slurp_raw, "\x34\x12", "test_data.bin contents");

done_testing();

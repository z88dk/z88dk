#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#

use Modern::Perl;
use Test::More;
use Path::Tiny;
use Capture::Tiny::Extended 'capture';
require './t/test_utils.pl';

# empty input file
path("test.asm")->spew("");
run("./z80asm -b test.asm");
ok -f "test.o", 	"output object file exists";
ok -f "test.bin", 	"output binary file exists";
t_binary(path("test.bin")->slurp_raw, "");

# empty section - FAILS
path("test.asm")->spew(<<'END');
	section CODE
	org 0
	ret
	
	section DATA
	org $8000
	defb 0
	
	section BSS
	org -1
END
run("./z80asm -b test.asm");


unlink_testfiles();
done_testing;

sub run {
	my($cmd, $out, $err) = @_;
	ok 1, $cmd;
	my($stdout, $stderr, $return) = capture { system $cmd; };
	is $stdout, ($out // ""), "stdout";
	is $stderr, ($err // ""), "stderr";
	ok $return == 0, "exit value";
}

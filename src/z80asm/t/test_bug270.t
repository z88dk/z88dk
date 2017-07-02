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

my $exp_map = norm_nl(<<'END');
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
eq_or_diff norm_nl(scalar(path("test1.map"))->slurp), $exp_map, "mapfile contents";

unlink_testfiles();
path("test1.asm")->spew($test1_asm);
path("test2.asm")->spew($test2_asm);
run("./z80asm test1.asm");
run("./z80asm test2.asm");
run("./z80asm -b -o=test -m test1.o test2.o");
t_binary(path("test_CODE.bin")->slurp_raw, pack("C*", 1, 2, 3, 4, 5));
t_binary(path("test_DATA.bin")->slurp_raw, pack("C*", 10, 11, 12, 13));
t_binary(path("test_BSS.bin")->slurp_raw, pack("C*", 0, 0, 0));
eq_or_diff norm_nl(scalar(path("test1.map"))->slurp), $exp_map, "mapfile contents";

unlink_testfiles();
path("test.c")->spew(<<END);
	// DATA
	unsigned char data[] = "Hello";

	// BSS
	unsigned buffer[100];

	// CODE
	int main(void)
	{
		return 1;
	}
END

# C test code that causes failure
if (0) {
	run("zcc +z80 -v -clib=sdcc_iy test.c -o test -m");

	ok -f "test_CODE.bin", "test_CODE.bin exists";
	ok -s "test_CODE.bin" >= 4, "test_CODE.bin size OK";
	my $code = path("test_CODE.bin")->slurp_raw;
	ok $code =~ /\x21\x01\x00\xc9\x00\z/, "test_CODE.bin contents";

	ok -f "test_DATA.bin", "test_DATA.bin exists";
	ok -s "test_DATA.bin" >= 6, "test_DATA.bin size OK";
	my $data = path("test_DATA.bin")->slurp_raw;
	ok $data =~ /Hello\0\z/, "test_DATA.bin contents";

	ok -f "test_BSS.bin", "test_BSS.bin exists";
	ok -s "test_BSS.bin" >= 200, "test_BSS.bin size OK";
	my $bss = path("test_BSS.bin")->slurp_raw;
	my $buffer = "\0" x 200;
	ok $bss =~ /$buffer\z/, "test_BSS.bin contents";
}

# reduce C exmaple above to minimum that reproduces failure
unlink_testfiles();
path("test1.asm")->spew(<<'END');
	section CODE
	ORG $0000
	
	section code_compiler

	section DATA
	ORG $8000
	
	section data_compiler
	
	section BSS
	ORG -1 ; section split

	section bss_compiler
END
path("test2.asm")->spew(<<END);
	section bss_compiler
	defs 100*2, 0

	section code_compiler
	ld hl, 1
	ret

	section data_compiler
	defb "Hello", 0
END
run("./z80asm test1.asm");
run("./z80asm test2.asm");
run("./z80asm -b -o=test -m test1.o test2.o");

ok -f "test_CODE.bin", "test_CODE.bin exists";
ok -s "test_CODE.bin" >= 4, "test_CODE.bin size OK";
my $code = path("test_CODE.bin")->slurp_raw;
ok $code =~ /\x21\x01\x00\xc9\z/, "test_CODE.bin contents";

ok -f "test_DATA.bin", "test_DATA.bin exists";
ok -s "test_DATA.bin" >= 6, "test_DATA.bin size OK";
my $data = path("test_DATA.bin")->slurp_raw;
ok $data =~ /Hello\0\z/, "test_DATA.bin contents";

ok -f "test_BSS.bin", "test_BSS.bin exists";
ok -s "test_BSS.bin" >= 200, "test_BSS.bin size OK";
my $bss = path("test_BSS.bin")->slurp_raw;
my $buffer = "\0" x 200;
ok $bss =~ /$buffer\z/, "test_BSS.bin contents";

done_testing;

sub run {
	my($cmd, $out, $err) = @_;
	ok 1, $cmd;
	my($stdout, $stderr, $return) = capture { system $cmd; };
	is $stdout, ($out // ""), "stdout";
	is $stderr, ($err // ""), "stderr";
	ok $return == 0, "exit value";
}

sub norm_nl {
	local $_ = shift;
	s/[ \t\r]+\n/\n/g;
	return $_;
}

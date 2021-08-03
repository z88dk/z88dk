#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/270
# z80asm: ignoring org -1 for sections when data is in object file separate from memory map file

use Modern::Perl;
use Test::More;
require './t/testlib.pl';


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
	__head                          = $0000 ; const, public, def, , ,
	__tail                          = $8007 ; const, public, def, , ,
	__size                          = $8007 ; const, public, def, , ,
	__CODE_head                     = $0000 ; const, public, def, , ,
	__CODE_tail                     = $0005 ; const, public, def, , ,
	__CODE_size                     = $0005 ; const, public, def, , ,
	__DATA_head                     = $8000 ; const, public, def, , ,
	__DATA_tail                     = $8004 ; const, public, def, , ,
	__DATA_size                     = $0004 ; const, public, def, , ,
	__BSS_head                      = $8004 ; const, public, def, , ,
	__BSS_tail                      = $8007 ; const, public, def, , ,
	__BSS_size                      = $0003 ; const, public, def, , ,
END


for my $one_step (0, 1) {
	unlink_testfiles();
	spew("test1.asm", $test1_asm);
	spew("test2.asm", $test2_asm);

	if ($one_step) {
		run("./z88dk-z80asm -b -o=test -m test1.asm test2.asm");
	}
	else {
		run("./z88dk-z80asm test1.asm");
		run("./z88dk-z80asm test2.asm");
		run("./z88dk-z80asm -b -o=test -m test1.o test2.o");
	}


	check_bin_file("test_CODE.bin",	pack("C*", 1, 2, 3, 4, 5));
	check_bin_file("test_DATA.bin",	pack("C*", 10, 11, 12, 13));
	check_bin_file("test_BSS.bin", 	pack("C*", 0, 0, 0));
	check_text_file("test1.map", $exp_map);
}


# C test code that causes failure
if (0) {
	unlink_testfiles();
	spew("test.c", <<'END');
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

	run("zcc +z80 -v -clib=sdcc_iy test.c -o test -m");

	ok -f "test_CODE.bin", "test_CODE.bin exists";
	ok -s "test_CODE.bin" >= 4, "test_CODE.bin size OK";
	my $code = slurp("test_CODE.bin");
	ok $code =~ /\x21\x01\x00\xc9\x00\z/, "test_CODE.bin contents";

	ok -f "test_DATA.bin", "test_DATA.bin exists";
	ok -s "test_DATA.bin" >= 6, "test_DATA.bin size OK";
	my $data = slurp("test_DATA.bin");
	ok $data =~ /Hello\0\z/, "test_DATA.bin contents";

	ok -f "test_BSS.bin", "test_BSS.bin exists";
	ok -s "test_BSS.bin" >= 200, "test_BSS.bin size OK";
	my $bss = slurp("test_BSS.bin");
	my $buffer = "\0" x 200;
	ok $bss =~ /$buffer\z/, "test_BSS.bin contents";
}


# reduce C exmaple above to minimum that reproduces failure
unlink_testfiles();
spew("test1.asm", <<'END');
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
spew("test2.asm", <<'END');
	section bss_compiler
	defs 100*2, 0

	section code_compiler
	ld hl, 1
	ret

	section data_compiler
	defb "Hello", 0
END

run("./z88dk-z80asm test1.asm");
run("./z88dk-z80asm test2.asm");
run("./z88dk-z80asm -b -o=test -m test1.o test2.o");

ok -f "test_CODE.bin", "test_CODE.bin exists";
ok -s "test_CODE.bin" >= 4, "test_CODE.bin size OK";
my $code = slurp("test_CODE.bin");
ok $code =~ /\x21\x01\x00\xc9\z/, "test_CODE.bin contents";

ok -f "test_DATA.bin", "test_DATA.bin exists";
ok -s "test_DATA.bin" >= 6, "test_DATA.bin size OK";
my $data = slurp("test_DATA.bin");
ok $data =~ /Hello\0\z/, "test_DATA.bin contents";

ok -f "test_BSS.bin", "test_BSS.bin exists";
ok -s "test_BSS.bin" >= 200, "test_BSS.bin size OK";
my $bss = slurp("test_BSS.bin");
my $buffer = "\0" x 200;
ok $bss =~ /$buffer\z/, "test_BSS.bin contents";


unlink_testfiles();
done_testing;

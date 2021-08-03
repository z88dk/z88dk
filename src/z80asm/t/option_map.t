#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test map file

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

# - BUG_0036 : Map file does not show local symbols with the same name in different modules
# If the same local symbol is defined in multiple modules, only one of
# them appears in the map file.
my $asm = "
	define not_shown
	defc zero=0
	PUBLIC main
main: ld b,10
loop: djnz loop
	PUBLIC last
last:
x31_x31_x31_x31_x31_x31_x31_x31: defb zero
x_32_x32_x32_x32_x32_x32_x32_x32: defb zero
";
my $asm_s = " ld b,10 \n djnz ASMPC \n defw 0 ";

my $asm1 = "
	define not_shown
	
	; show DEFC alias in map file
	PUBLIC alias_main
	EXTERN main
	defc alias_main = main
	
	PUBLIC alias_last
	EXTERN last
	defc alias_last = last

	PUBLIC func
func: ld b,10
loop: djnz loop
	  ret
";
my $asm1_s = " ld b,10 \n djnz ASMPC \n ret ";

my $bin = "\x06\x0A\x10\xFE\x00\x00\x06\x0A\x10\xFE\xC9";


# no -m
unlink_testfiles();
spew("test.asm", $asm_s);
spew("test1.asm", $asm1_s);
run("./z88dk-z80asm -b test.asm test1.asm");
ok ! -f "test.map", "no test.map";
check_bin_file("test.bin", $bin);


# -m, no symbols
unlink_testfiles();
spew("test.asm", $asm_s);
spew("test1.asm", $asm1_s);
run("./z88dk-z80asm -b -m test.asm test1.asm");
ok -f "test.map", "found test.map";
check_bin_file("test.bin", $bin);
check_text_file("test.map", <<'END');
		__head                          = $0000 ; const, public, def, , ,
		__tail                          = $000B ; const, public, def, , ,
		__size                          = $000B ; const, public, def, , ,
END


# -m, symbols
unlink_testfiles();
spew("test.asm", $asm);
spew("test1.asm", $asm1);
run("./z88dk-z80asm -b -m test.asm test1.asm");
ok -f "test.map", "found test.map";
check_bin_file("test.bin", $bin);
check_text_file("test.map", <<'END');
	zero                            = $0000 ; const, local, , test, , test.asm:3
	loop                            = $0002 ; addr, local, , test, , test.asm:6
	x31_x31_x31_x31_x31_x31_x31_x31 = $0004 ; addr, local, , test, , test.asm:9
	x_32_x32_x32_x32_x32_x32_x32_x32 = $0005 ; addr, local, , test, , test.asm:10
	loop                            = $0008 ; addr, local, , test1, , test1.asm:15
	main                            = $0000 ; addr, public, , test, , test.asm:5
	last                            = $0004 ; addr, public, , test, , test.asm:8
	alias_main                      = $0000 ; addr, public, , test1, , test1.asm:7
	alias_last                      = $0004 ; addr, public, , test1, , test1.asm:11
	func                            = $0006 ; addr, public, , test1, , test1.asm:14
	__head                          = $0000 ; const, public, def, , ,
	__tail                          = $000B ; const, public, def, , ,
	__size                          = $000B ; const, public, def, , ,
END

unlink_testfiles();
done_testing();

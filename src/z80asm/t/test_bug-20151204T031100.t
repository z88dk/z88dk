#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Bug report:
# alvin (alvin_albrecht@hotmail.com) <lists@suborbital.org.uk> Fri, Dec 4, 2015 at 3:11 AM 
# To: z88dk-developers@lists.sourceforge.net 
# The two labels are not equal despite the defc.
# When the expression to be computed is based on symbols from different sections
# or modules, the evaluation needs to be postponed to the link phase.

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
spew("test.asm", "
		SECTION AAA
		org 0
		SECTION BBB
		SECTION CCC


		SECTION AAA
		defw var_1			;; 02 00

		SECTION BBB

		var_1:
		defb 205			;; CD

		SECTION CCC
		defw var_1			;; 02 00	

		defc var_2 = var_1
");
run("./z88dk-z80asm -b -m test.asm");
ok -f "test_AAA.bin", "test_AAA.bin";
ok -f "test.map", "no test.map";
check_bin_file("test_AAA.bin", "\x02\x00\xCD\x02\x00");
check_text_file("test.map", <<'END');
var_1                           = $0002 ; addr, local, , test, BBB, test.asm:13
var_2                           = $0002 ; addr, local, , test, CCC, test.asm:19
__head                          = $0000 ; const, public, def, , ,
__tail                          = $0005 ; const, public, def, , ,
__size                          = $0005 ; const, public, def, , ,
__AAA_head                      = $0000 ; const, public, def, , ,
__AAA_tail                      = $0002 ; const, public, def, , ,
__AAA_size                      = $0002 ; const, public, def, , ,
__BBB_head                      = $0002 ; const, public, def, , ,
__BBB_tail                      = $0003 ; const, public, def, , ,
__BBB_size                      = $0001 ; const, public, def, , ,
__CCC_head                      = $0003 ; const, public, def, , ,
__CCC_tail                      = $0005 ; const, public, def, , ,
__CCC_size                      = $0002 ; const, public, def, , ,
END

unlink_testfiles();
spew("test.asm", "
		SECTION AAA
		org 0
		SECTION BBB
		SECTION CCC


		SECTION AAA
		defw var_1			;; 02 00

		SECTION BBB

		var_1:
		defb 205			;; CD

		SECTION CCC
		defw var_1			;; 02 00

		SECTION BBB
		defc var_2 = var_1
");
run("./z88dk-z80asm -b -m test.asm");
ok -f "test_AAA.bin", "test_AAA.bin";
ok -f "test.map", "no test.map";
check_bin_file("test_AAA.bin", "\x02\x00\xCD\x02\x00");
check_text_file("test.map", <<'END');
var_1                           = $0002 ; addr, local, , test, BBB, test.asm:13
var_2                           = $0002 ; addr, local, , test, BBB, test.asm:20
__head                          = $0000 ; const, public, def, , ,
__tail                          = $0005 ; const, public, def, , ,
__size                          = $0005 ; const, public, def, , ,
__AAA_head                      = $0000 ; const, public, def, , ,
__AAA_tail                      = $0002 ; const, public, def, , ,
__AAA_size                      = $0002 ; const, public, def, , ,
__BBB_head                      = $0002 ; const, public, def, , ,
__BBB_tail                      = $0003 ; const, public, def, , ,
__BBB_size                      = $0001 ; const, public, def, , ,
__CCC_head                      = $0003 ; const, public, def, , ,
__CCC_tail                      = $0005 ; const, public, def, , ,
__CCC_size                      = $0002 ; const, public, def, , ,
END

unlink_testfiles();
done_testing();

#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test -debug info in map file

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

# only ASM code
spew("test1.asm", <<END);
	public func

	c_line 1, "test1.c"
func:
	ld a, 1
	ld b, 3
	
	c_line 2
	add a, b
	ret
END

spew("test.asm", <<END);
	extern func

main:
	call func
	ret
END

run("./z88dk-z80asm -b -m test.asm test1.asm");
check_text_file("test.map", <<'END');
main                            = $0000 ; addr, local, , test, , test.asm:3
func                            = $0004 ; addr, public, , test1, , test1.c:1
__head                          = $0000 ; const, public, def, , ,
__tail                          = $000A ; const, public, def, , ,
__size                          = $000A ; const, public, def, , ,
END

run("./z88dk-z80asm -b -debug test.asm test1.asm");
check_text_file("test.map", <<'END');
main                            = $0000 ; addr, local, , test, , test.asm:3
__ASM_LINE_3_test_2easm         = $0000 ; addr, local, , test, , test.asm:3
__ASM_LINE_4_test_2easm         = $0000 ; addr, local, , test, , test.asm:4
__ASM_LINE_5_test_2easm         = $0003 ; addr, local, , test, , test.asm:5
__C_LINE_1_test1_2ec            = $0004 ; addr, local, , test1, , test1.c:1
__C_LINE_2_test1_2ec            = $0008 ; addr, local, , test1, , test1.c:2
func                            = $0004 ; addr, public, , test1, , test1.c:1
__head                          = $0000 ; const, public, def, , ,
__tail                          = $000A ; const, public, def, , ,
__size                          = $000A ; const, public, def, , ,
END


# ASM and C code
unlink_testfiles();
spew("test1.asm", <<END);
	public _one
_one:
	ld hl, 1
	ret
END

spew("test.h", <<END);
// some
// random
extern int one();
// lines
END

spew("test.c", <<END);
#include "test.h"
int main() {
	return one()+one();
}
END

run("zcc +zx -m -debug test.c test1.asm -o test.bin");
my $map = join("\n", grep {/test.c:|test.h:|test1.asm:/} split('\n', slurp("test.map")))."\n";
check_text($map, <<'END', "map file contents");
__C_LINE_0_test_2ec             = $80CD ; addr, local, , test_c, , test.c:0
__C_LINE_1_test_2ec             = $80CD ; addr, local, , test_c, , test.c:1
__C_LINE_0_test_2eh             = $80CD ; addr, local, , test_c, , test.h:0
__C_LINE_1_test_2eh             = $80CD ; addr, local, , test_c, , test.h:1
__C_LINE_2_test_2eh             = $80CD ; addr, local, , test_c, , test.h:2
__C_LINE_3_test_2eh             = $80CD ; addr, local, , test_c, , test.h:3
__C_LINE_4_test_2eh             = $80CD ; addr, local, , test_c, , test.h:4
__C_LINE_5_test_2eh             = $80CD ; addr, local, , test_c, , test.h:5
__C_LINE_2_test_2ec             = $80CD ; addr, local, , test_c, , test.c:2
__C_LINE_2_test_2ec_3a_3amain_3a_3a0_3a_3a1 = $8286 ; addr, local, , test_c, code_compiler, test.c::main::0::1:2
__C_LINE_3_test_2ec_3a_3amain_3a_3a1_3a_3a2 = $8289 ; addr, local, , test_c, code_compiler, test.c::main::1::2:3
__C_LINE_4_test_2ec_3a_3amain_3a_3a1_3a_3a2 = $8296 ; addr, local, , test_c, code_compiler, test.c::main::1::2:4
__ASM_LINE_2_test1_2easm        = $80CD ; addr, local, , test1_asm, , test1.asm:2
__ASM_LINE_3_test1_2easm        = $80CD ; addr, local, , test1_asm, , test1.asm:3
__ASM_LINE_4_test1_2easm        = $80D0 ; addr, local, , test1_asm, , test1.asm:4
_main                           = $8286 ; addr, public, , test_c, code_compiler, test.c::main::0::1:2
__CDBINFO__F_3aG_24main_24_30_5f_30_24_30_28_7b_30_7dDF_2cSI_3aS_29_2cC_2c_30_2c_30_2c_30_2c_30_2c_30 = $0001 ; const, public, , test_c, code_compiler, test.c::main::1::2:4
_one                            = $80CD ; addr, public, , test1_asm, , test1.asm:2
END

unlink_testfiles();
done_testing();

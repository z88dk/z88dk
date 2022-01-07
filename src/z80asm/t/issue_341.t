#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/341
# z80asm: Produce a debugger-friendly filename/bank/memory address file

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
spew("test1.asm", <<END);
	public func
func:
	ret
END

spew("test.c", <<END);
int add(int a, int b) 
{
	return a+b;
}

int main()
{
	int a = 4;
	int b = 6;
	int s = add(a,b);
	return s;
}
END

run("zcc +z80 -m -clib=new -Cc-gcline -Ca-debug test.c test1.asm -otest.bin", 0, 'IGNORE', '');
my $map = join("\n", grep {/test.c:|test1.asm:/} split('\n', slurp("test.map")))."\n";
check_text($map, <<'END', "map file contents");
__C_LINE_0_test_2ec             = $0000 ; addr, local, , test_c, , test.c:0
__C_LINE_1_test_2ec             = $0000 ; addr, local, , test_c, , test.c:1
__C_LINE_2_test_2ec_3a_3aadd_3a_3a0_3a_3a0 = $016E ; addr, local, , test_c, code_compiler, test.c::add::0::0:2
__C_LINE_3_test_2ec_3a_3aadd_3a_3a1_3a_3a1 = $016E ; addr, local, , test_c, code_compiler, test.c::add::1::1:3
__C_LINE_6_test_2ec_3a_3aadd_3a_3a0_3a_3a1 = $017B ; addr, local, , test_c, code_compiler, test.c::add::0::1:6
__C_LINE_7_test_2ec_3a_3amain_3a_3a0_3a_3a2 = $017B ; addr, local, , test_c, code_compiler, test.c::main::0::2:7
__C_LINE_8_test_2ec_3a_3amain_3a_3a1_3a_3a3 = $017B ; addr, local, , test_c, code_compiler, test.c::main::1::3:8
__C_LINE_9_test_2ec_3a_3amain_3a_3a1_3a_3a3 = $017F ; addr, local, , test_c, code_compiler, test.c::main::1::3:9
__C_LINE_10_test_2ec_3a_3amain_3a_3a1_3a_3a3 = $0183 ; addr, local, , test_c, code_compiler, test.c::main::1::3:10
__C_LINE_11_test_2ec_3a_3amain_3a_3a1_3a_3a3 = $0183 ; addr, local, , test_c, code_compiler, test.c::main::1::3:11
__ASM_LINE_2_test1_2easm        = $0000 ; addr, local, , test1_asm, , test1.asm:2
__ASM_LINE_3_test1_2easm        = $0000 ; addr, local, , test1_asm, , test1.asm:3
_add                            = $016E ; addr, public, , test_c, code_compiler, test.c::add::0::0:2
_main                           = $017B ; addr, public, , test_c, code_compiler, test.c::main::0::2:7
func                            = $0000 ; addr, public, , test1_asm, , test1.asm:2
END

unlink_testfiles();
done_testing();

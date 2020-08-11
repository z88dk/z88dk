#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
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
__C_LINE_0                      = $0000 ; addr, local, , test_c, , test.c:0
__C_LINE_2                      = $0000 ; addr, local, , test_c, , test.c:2
__C_LINE_3                      = $017D ; addr, local, , test_c, code_compiler, test.c::add:3
__C_LINE_4                      = $018D ; addr, local, , test_c, code_compiler, test.c::add:4
__C_LINE_6                      = $018D ; addr, local, , test_c, code_compiler, test.c::add:6
__C_LINE_7                      = $018D ; addr, local, , test_c, code_compiler, test.c::add:7
__C_LINE_8                      = $018D ; addr, local, , test_c, code_compiler, test.c::main:8
__C_LINE_9                      = $0191 ; addr, local, , test_c, code_compiler, test.c::main:9
__C_LINE_10                     = $0195 ; addr, local, , test_c, code_compiler, test.c::main:10
 __C_LINE_11                     = $0195 ; addr, local, , test_c, code_compiler, test.c::main:11
 __C_LINE_12                     = $01A9 ; addr, local, , test_c, code_compiler, test.c::main:12
 __ASM_LINE_2                    = $0000 ; addr, local, , test1_asm, , test1.asm:2
 __ASM_LINE_3                    = $0000 ; addr, local, , test1_asm, , test1.asm:3
 _add                            = $017D ; addr, public, , test_c, code_compiler, test.c::add:2
 _main                           = $018D ; addr, public, , test_c, code_compiler, test.c::main:7
func                            = $0000 ; addr, public, , test1_asm, , test1.asm:2
END

unlink_testfiles();
done_testing();

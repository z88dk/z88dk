#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/341
# z80asm: Produce a debugger-friendly filename/bank/memory address file

unlink_testfiles;
spew("${test}1.asm", <<END);
	public func
func:
	ret
END

spew("${test}.c", <<END);
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

run_ok("zcc +z80 -m -clib=new -Cc-gcline -Ca-debug ${test}.c ${test}1.asm -o${test}.bin");

(my $test_expanded = $test) =~ s/([^a-z0-9])/ sprintf("_%02x", ord($1)) /ige;
my @map = grep {!/zcc|crt|asm_dzx7/ && /$test_expanded|_main|_add|func/} 
		  path("${test}.map")->lines;
spew("${test}1.map", @map);

check_text_file("${test}1.map", <<END);
__C_LINE_0_${test_expanded}_2ec = \$0000 ; addr, local, , ${test}_c, , ${test}.c:0
__C_LINE_1_${test_expanded}_2ec = \$0000 ; addr, local, , ${test}_c, , ${test}.c:1
__C_LINE_2_${test_expanded}_2ec_3a_3aadd_3a_3a0_3a_3a0 = \$0180 ; addr, local, , ${test}_c, code_compiler, ${test}.c::add::0::0:2
__C_LINE_3_${test_expanded}_2ec_3a_3aadd_3a_3a1_3a_3a1 = \$0180 ; addr, local, , ${test}_c, code_compiler, ${test}.c::add::1::1:3
__C_LINE_6_${test_expanded}_2ec_3a_3aadd_3a_3a0_3a_3a1 = \$018C ; addr, local, , ${test}_c, code_compiler, ${test}.c::add::0::1:6
__C_LINE_7_${test_expanded}_2ec_3a_3amain_3a_3a0_3a_3a2 = \$018C ; addr, local, , ${test}_c, code_compiler, ${test}.c::main::0::2:7
__C_LINE_8_${test_expanded}_2ec_3a_3amain_3a_3a1_3a_3a3 = \$018C ; addr, local, , ${test}_c, code_compiler, ${test}.c::main::1::3:8
__C_LINE_9_${test_expanded}_2ec_3a_3amain_3a_3a1_3a_3a3 = \$0190 ; addr, local, , ${test}_c, code_compiler, ${test}.c::main::1::3:9
__C_LINE_10_${test_expanded}_2ec_3a_3amain_3a_3a1_3a_3a3 = \$0194 ; addr, local, , ${test}_c, code_compiler, ${test}.c::main::1::3:10
__C_LINE_11_${test_expanded}_2ec_3a_3amain_3a_3a1_3a_3a3 = \$0194 ; addr, local, , ${test}_c, code_compiler, ${test}.c::main::1::3:11
__ASM_LINE_2_${test_expanded}1_2easm = \$0000 ; addr, local, , ${test}1_asm, , ${test}1.asm:2
_add                            = \$0180 ; addr, public, , ${test}_c, code_compiler, ${test}.c::add::0::0:2
_main                           = \$018C ; addr, public, , ${test}_c, code_compiler, ${test}.c::main::0::2:7
func                            = \$0000 ; addr, public, , ${test}1_asm, , ${test}1.asm:2
END


unlink_testfiles;
done_testing;

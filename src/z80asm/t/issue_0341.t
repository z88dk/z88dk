#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/341
# z80asm: Produce a debugger-friendly filename/bank/memory address file

unlink_testfiles;
spew( "${test}1.asm", <<END );
	public func
func:
	ret
END

spew( "${test}.c", <<END );
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

run_ok(
"zcc +z80 -m -clib=new -Cc-gcline -Ca-debug ${test}.c ${test}1.asm -o${test}.bin"
);

( my $test_expanded = $test ) =~ s/([^a-z0-9])/ sprintf("_%02x", ord($1)) /ige;
my @map = grep { !/zcc|crt|asm_dzx7/ && /$test_expanded|_main|_add|func/ }
    path("${test}.map")->lines;
spew( "${test}1.map", @map );

# The load address follows the linked newlib. A rebuilt malloc and the
# nightly libraries used by the Windows msbuild jobs do not share a base.
my ($add_addr) = map { /^_add\s+=\s+\$([0-9A-Fa-f]+)/ ? hex($1) : () } @map;
ok( defined $add_addr && $add_addr > 0, "_add has a load address" ) or die;
my $add    = sprintf( '%04X', $add_addr );
my $main   = sprintf( '%04X', $add_addr + 0x0C );
my $line9  = sprintf( '%04X', $add_addr + 0x10 );
my $line10 = sprintf( '%04X', $add_addr + 0x14 );
my $line11 = sprintf( '%04X', $add_addr + 0x25 );

check_text_file( "${test}1.map", <<END );
__ASM_LINE_2_${test_expanded}1_2easm = \$0000 ; addr, local, , ${test}1_asm, , ${test}1.asm:2
__C_LINE_0_${test_expanded}_2ec = \$0000 ; addr, local, , ${test}_c, , ${test}.c:0
__C_LINE_10_${test_expanded}_2ec_3a_3amain_3a_3a1_3a_3a3 = \$$line10 ; addr, local, , ${test}_c, code_compiler, ${test}.c::main::1::3:10
__C_LINE_11_${test_expanded}_2ec_3a_3amain_3a_3a1_3a_3a3 = \$$line11 ; addr, local, , ${test}_c, code_compiler, ${test}.c::main::1::3:11
__C_LINE_1_${test_expanded}_2ec = \$0000 ; addr, local, , ${test}_c, , ${test}.c:1
__C_LINE_2_${test_expanded}_2ec_3a_3aadd_3a_3a0_3a_3a0 = \$$add ; addr, local, , ${test}_c, code_compiler, ${test}.c::add::0::0:2
__C_LINE_3_${test_expanded}_2ec_3a_3aadd_3a_3a1_3a_3a1 = \$$add ; addr, local, , ${test}_c, code_compiler, ${test}.c::add::1::1:3
__C_LINE_6_${test_expanded}_2ec_3a_3aadd_3a_3a0_3a_3a1 = \$$main ; addr, local, , ${test}_c, code_compiler, ${test}.c::add::0::1:6
__C_LINE_7_${test_expanded}_2ec_3a_3amain_3a_3a0_3a_3a2 = \$$main ; addr, local, , ${test}_c, code_compiler, ${test}.c::main::0::2:7
__C_LINE_8_${test_expanded}_2ec_3a_3amain_3a_3a1_3a_3a3 = \$$main ; addr, local, , ${test}_c, code_compiler, ${test}.c::main::1::3:8
__C_LINE_9_${test_expanded}_2ec_3a_3amain_3a_3a1_3a_3a3 = \$$line9 ; addr, local, , ${test}_c, code_compiler, ${test}.c::main::1::3:9
_add                            = \$$add ; addr, public, , ${test}_c, code_compiler, ${test}.c::add::0::0:2
_main                           = \$$main ; addr, public, , ${test}_c, code_compiler, ${test}.c::main::0::2:7
func                            = \$0000 ; addr, public, , ${test}1_asm, , ${test}1.asm:2
END

unlink_testfiles;
done_testing;

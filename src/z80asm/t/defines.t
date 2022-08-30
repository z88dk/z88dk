#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

z80asm_ok("", "", "",
		'nop'					=> bytes(0));

z80asm_nok("", "", "#define", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- #define
END_ERR

z80asm_nok("", "", "#undef", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- #undef
END_ERR

z80asm_ok("", "", "",
		'#ignored',		"");

z80asm_ok("", "", "",
		'#define nil nop',		=> "",
		'nil'					=> bytes(0));

z80asm_ok("", "", "",
		'#define nil 0'			=> "",
		'#undef nil'			=> "",
		'#UNDEF nil ; ignored'	=> "",
		'#DEFINE nil nop'		=> "",
		'nil'					=> bytes(0));

z80asm_ok("", "", "",
		'#define label here'	=> "",
		'.label jp here'		=> bytes(0xc3, 0, 0));

z80asm_nok("", "", <<END_ASM, <<END_ERR);
#define nil nop
#define nil nop
END_ASM
$test.asm:2: error: duplicate definition: nil
  ^---- #define nil nop
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
#define .3 nop
#define 3 nop
END_ASM
$test.asm:1: error: syntax error
  ^---- #define .3 nop
$test.asm:2: error: syntax error
  ^---- #define 3 nop
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
#define abc(a,b,a) a+b+a
END_ASM
$test.asm:1: error: duplicate definition: a
  ^---- #define abc(a,b,a) a+b+a
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
#define abc(a,b a+b
END_ASM
$test.asm:1: error: syntax error
  ^---- #define abc(a,b a+b
END_ERR

z80asm_ok("", "", "",
		'#define abc(a,b) a+b'	=> "",
		'defb abc(1,2); comment'=> bytes(3),
		'defb abc 1,2 ; comment'=> bytes(3));

z80asm_ok("", "", "",
		'#define abc defb'		=> "",
		'abc 1,2'				=> bytes(1,2));

z80asm_ok("", "", "",
		'#define pusha \\'		=> "",
		'push bc \\ \\'			=> "",
		'push de \\ \\'			=> "",
		'push hl'				=> "",
		'pusha'					=> bytes(0xc5, 0xd5, 0xe5));

z80asm_ok("", "", "",
		'#define COMMA ,'		=> "",
		'#define LOAD(x) ld x'	=> "",
		'LOAD a COMMA b'		=> bytes(0x78),
		'LOAD(a COMMA b)'		=> bytes(0x78));

z80asm_ok("", "", "",
		'#define ret nop'		=> "",
		'ret'					=> bytes(0));

spew("$test.1.asm", <<END);
#define ret nop
END
spew("$test.2.asm", <<END);
ret
END

run_ok("z88dk-z80asm -b $test.1.asm $test.2.asm");
check_bin_file("$test.1.bin", bytes(0xc9));

z80asm_ok("", "", "",
		'#define cat(a, b) a ## b'		=> "",
		'cat(aa,bb): jp aabb'			=> bytes(0xc3, 0, 0));

unlink_testfiles();
done_testing();

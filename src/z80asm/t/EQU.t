#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $equ ('equ', '=') {
	my $space = $equ eq 'equ' ? ' ' : '';
	ok 1, "Test with '$space$equ'";

	z80asm_nok("", "", "aa $equ", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- aa $equ
END_ERR

	z80asm_nok("", "", "aa $equ 1,", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- aa $equ 1,
END_ERR

	z80asm_nok("", "", ".aa: $equ 1", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- .aa: $equ 1
      ^---- $equ${space}1
END_ERR

	z80asm_ok("", "", "", 
		"a1 $equ 1+1"					=> "",
		"b1 $equ 2+2, c1 $equ 3+3"		=> "",
		"   defb a1,b1,c1"				=> bytes(2,4,6));

	z80asm_ok("", "", "", 
		"#define set equ"				=> "",
		"one=1"							=> "",
		" two    =    2"				=> "",
		" .three equ  3"				=> "",
		" four:  Equ  4"				=> "",
		"five    EQU  5"				=> "",
		" six    set  6"				=> "",
		" .seven equ  7"				=> "",
		" eight: equ  8"				=> "",
		"defb one,two,three,four,five,six,seven,eight" 
										=> bytes(1..8));
}

unlink_testfiles;
done_testing;

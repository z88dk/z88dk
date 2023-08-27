#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		defb (2
		defb (2+[
		defb (2+[3-1]
		defb (2+[3-1)]
END_ASM
$test.asm:1: error: syntax error in expression
  ^---- defb (2
$test.asm:2: error: syntax error
  ^---- defb (2+[
$test.asm:3: error: syntax error in expression
  ^---- defb (2+[3-1]
$test.asm:4: error: syntax error in expression
  ^---- defb (2+[3-1)]
END_ERR

unlink_testfiles;
done_testing;

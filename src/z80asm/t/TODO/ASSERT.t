#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# z80asm: Request for ASSERT directive for z80asm
# https://github.com/z88dk/z88dk/issues/1898

z80asm_ok("", "", "", <<'END_ASM', bytes(0, 1, 3));
L1:		assert 1			; constant
		defb L1
L2:
		assert 2			; constant !=0
		defb L2
		
		assert L2-L1==1		; expression containing already defined labels
		
		defc X1 = 3
		assert X1			; expression containing defc constants
		defb X1
		
		assert $==3			; expression containing ASMPC
END_ASM

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		assert
END_ASM
$test.asm:1: error: syntax error
  ^---- assert
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		extern xxx
		assert xxx
END_ASM
$test.asm:2: error: constant expression expected
  ^---- assert xxx
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		assert 0
END_ASM
$test.asm:1: error: assertion failed
  ^---- assert 0
END_ERR

unlink_testfiles;
done_testing;

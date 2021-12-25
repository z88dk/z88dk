#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# z80asm: Request for ASSERT directive for z80asm
# https://github.com/z88dk/z88dk/issues/1898

z80asm_ok("", "", "", <<'END_ASM', bytes(0, 1, 3));
L1:		assert 1
		defb L1
L2:
		assert 2
		defb L2
		
		assert L2-L1==1
		
		defc X1 = 3
		assert X1
		defb X1
END_ASM

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		assert
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		extern xxx
		assert xxx
END_ASM
Error at file '$test.asm' line 2: expected constant expression
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		assert 0
END_ASM
Error at file '$test.asm' line 1: assertion failed
END_ERR

unlink_testfiles;
done_testing;

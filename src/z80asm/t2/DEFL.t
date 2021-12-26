#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
defl
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
defl a
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
defl a b
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_ok("", "", "", <<'END', bytes(1,2,3,3,5,7));
.val	defl val+1
		defb val
val:	DEFL val+1
		DEFB val
val		defl val+1
		defb val
		defl val = $
		defb val
		defl val = val+1		; $+1
		defb val
		defl val = val+1		; $+1+1
		defb val
END

unlink_testfiles;
done_testing;

#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# syntax
z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		exitm hello
END_ASM
$test.asm:1: error: syntax error
  ^---- exitm hello
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		exitm
END_ASM
$test.asm:1: error: unbalanced control structure
  ^---- exitm
END_ERR

# function
z80asm_ok("", "", "", <<'END', bytes(1));
		macro testmacro
		defb 1
		exitm
		defb 2
		endm
		testmacro
END

z80asm_ok("", "", "", <<'END', bytes(1, 1));
		macro testmacro
		defb 1
l1:		exitm
		defb 2
		endm
		testmacro
		defb l1
END

z80asm_ok("", "", "", <<'END', bytes(1, 1));
		macro testmacro
		defb 1
.l1		exitm
		defb 2
		endm
		testmacro
		defb l1
END

# continuation lines
z80asm_ok("", "", "", <<'END', bytes(1));
		macro testmacro \ defb 1 \ exitm \ defb 2 \ endm \ testmacro
END

# exitm within if
z80asm_ok("", "", "", <<'END', bytes(1,2, 1));
		macro testmacro op
		defb 1
		if op==1 \ exitm \ endif
		defb 2
		endm
		testmacro 0
		testmacro 1
END

z80asm_ok("", "", "", <<'END', bytes(1,2, 1, 1));
		macro testmacro op
		defb 1
		if op==1 \ exitm \ elif op==2 \ exitm \ endif
		defb 2
		endm
		testmacro 0
		testmacro 1
		testmacro 2		
END

z80asm_ok("", "", "", <<'END', bytes(1, 1,2));
		macro testmacro name
		defb 1
		ifdef name \ exitm \ endif
		defb 2
		endm
		defc abcd=0
		testmacro abcd
		testmacro efgh
END

z80asm_ok("", "", "", <<'END', bytes(1,2, 1));
		macro testmacro name
		defb 1
		ifndef name \ exitm \ endif
		defb 2
		endm
		defc abcd=0
		testmacro abcd
		testmacro efgh
END

z80asm_ok("", "", "", <<'END', bytes(1, 1,2));
		macro testmacro name
		defb 1
		if 0 \ exitm \ elifdef name \ exitm \ endif
		defb 2
		endm
		defc abcd=0
		testmacro abcd
		testmacro efgh
END

z80asm_ok("", "", "", <<'END', bytes(1,2, 1));
		macro testmacro name
		defb 1
		if 0 \ exitm \ elifndef name \ exitm \ endif
		defb 2
		endm
		defc abcd=0
		testmacro abcd
		testmacro efgh
END

unlink_testfiles;
done_testing;

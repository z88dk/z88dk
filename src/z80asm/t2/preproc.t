#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# test continuation lines
z80asm_ok("-b -l", "", "", <<'END', bytes(0x3e, 1));
ld a,\
1
END
check_txt_file("$test.lis", <<'END');
1     0000              ld a,\
2     0000  3E 01       1
3     0002              
4     0002              
END

# backslash at end of line inside a comment
z80asm_ok("", "", "", <<'END', bytes(0, 1, 2));
zero: equ 0 ;\
one   equ 1 ;\
.two  equ 2
defb zero,one,two
END

# test split lines
z80asm_ok("-b -l", "", "", <<'END', bytes(0x3e, 1, 0xc9));
ld a,1\ret
END
check_txt_file("$test.lis", <<'END');
1     0000  3E 01 C9    ld a,1\ret
2     0003              
3     0003              
END

# backslash inside a comment
z80asm_ok("", "", "", <<'END', bytes(0, 1, 2));
zero: equ 0 ;\ret
one   equ 1 ;\ret
.two  equ 2
defb zero,one,two
END

unlink_testfiles;
done_testing;

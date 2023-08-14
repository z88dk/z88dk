#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# test continuation lines
z80asm_ok("-b -l", "", "", <<'END', bytes(0x3e, 1));
ld a,\
1
END
check_text_file("$test.lis", <<'END');
test_t_preproc.asm:
     1                          ld a,\
     2  0000  3e01              1
     3                          
     4                          
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
check_text_file("$test.lis", <<'END');
test_t_preproc.asm:
     1  0000  3e01c9            ld a,1\ret
     2                          
     3                          
END

z80asm_ok("-b -l", "", "", <<'END', bytes(0x3e, 1, 0xc9));
ld a,1:ret
END
check_text_file("$test.lis", <<'END');
test_t_preproc.asm:
     1  0000  3e01c9            ld a,1:ret
     2                          
     3                          
END

z80asm_ok("-b -l", "", "", <<'END', bytes(0x3e, 1, 0xc9));
ld a,1\:\:ret
END
check_text_file("$test.lis", <<'END');
test_t_preproc.asm:
     1  0000  3e01c9            ld a,1\:\:ret
     2                          
     3                          
END

z80asm_ok("-b -l", "", "", <<'END', bytes(0x3e, 2, 0xc9));
ld a,1?2:3:ret
END
check_text_file("$test.lis", <<'END');
test_t_preproc.asm:
     1  0000  3e02c9            ld a,1?2:3:ret
     2                          
     3                          
END

z80asm_ok("-b -l", "", "", <<'END', bytes(0x3e, 3, 0xc9));
ld a,1?(2?3:4):5:ret
END
check_text_file("$test.lis", <<'END');
test_t_preproc.asm:
     1  0000  3e03c9            ld a,1?(2?3:4):5:ret
     2                          
     3                          
END

z80asm_ok("-b -l", "", "", <<'END', bytes(0,0,0, 0,1,2));
a1:nop:a2:nop:a3:nop
defb a1,a2,a3
END
check_text_file("$test.lis", <<'END');
test_t_preproc.asm:
     1  0000  000000            a1:nop:a2:nop:a3:nop
     2  0003  000102            defb a1,a2,a3
     3                          
     4                          
END

z80asm_ok("-b -l", "", "", <<'END', bytes(0,0,0, 0,1,2));
.a1 nop:.a2 nop:.a3 nop
defb a1,a2,a3
END
check_text_file("$test.lis", <<'END');
test_t_preproc.asm:
     1  0000  000000            .a1 nop:.a2 nop:.a3 nop
     2  0003  000102            defb a1,a2,a3
     3                          
     4                          
END

# test split inside a comment
z80asm_ok("-b -l", "", "", <<'END', bytes(0x3e, 1));
ld a,1;\:ret
END
check_text_file("$test.lis", <<'END');
test_t_preproc.asm:
     1  0000  3e01              ld a,1;\:ret
     2                          
     3                          
END

# backslash inside a comment
z80asm_ok("", "", "", <<'END', bytes(0, 1, 2));
zero: equ 0 ;\ret
one   equ 1 ;\ret
.two  equ 2
defb zero,one,two
END

# test ## concatenation
z80asm_ok("", "", "", <<'END', bytes(0));
zero equ 0
     defb ze \
	      ## \
		  ro
END

# continuation line without next line
z80asm_ok("", "", "", <<'END', bytes(0,1,2));
     defb 0 \ defb 1 \ defb 2 \
END

# IF label
z80asm_ok("", "", "", <<'END', bytes(0xc3, 0, 0));
if: if 1
jp if
endif
END

# quoted strings
z80asm_ok("", "", "", <<'END', bytes(7, 8, 27, 12, 10, 13, 9, 11, 0x5c, 0x27, 0x22));
defb '\a','\b','\e','\f','\n','\r','\t','\v','\\','\'','\"'
END

z80asm_ok("", "", "", <<'END', bytes(0, 1, 7, 8, 15, 16, 255));
defb '\0','\1','\7','\10','\17','\20','\377'
END

z80asm_ok("", "", "", <<'END', bytes(0, 1, 7, 8, 15, 16, 255));
defb '\x0','\x1','\x7','\x8','\xf','\x10','\xff'
END

z80asm_ok("", "", "", <<'END', bytes(7, 8, 27, 12, 10, 13, 9, 11, 0x5c, 0x27, 0x22));
defb "\a\b\e\f\n\r\t\v\\\'\""
END

z80asm_ok("", "", "", <<'END', bytes(0, 1, 7, 8, 15, 16, 255));
defb "\0\1\7\10\17\20\377"
END

z80asm_ok("", "", "", <<'END', bytes(0, 1, 7, 8, 15, 16, 255));
defb "\x0\x1\x7\x8\xf\x10\xff"
END

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
defb 'a
END_ASM
$test.asm:1: error: missing quote
  ^---- defb 'a
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
ld a, "ab"
END_ASM
$test.asm:1: error: syntax error
  ^---- ld a, "ab"
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
defb ''
END_ASM
$test.asm:1: error: invalid character constant
  ^---- defb ''
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
defb 'ab'
END_ASM
$test.asm:1: error: invalid character constant
  ^---- defb 'ab'
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
defb "a
END_ASM
$test.asm:1: error: missing quote
  ^---- defb "a
END_ERR

# invalid single quoted character was overflowing to next line
z80asm_nok("", "", <<'END_ASM', <<END_ERR);
ld a,'he'
ld a,"ab"
END_ASM
$test.asm:1: error: invalid character constant
  ^---- ld a,'he'
$test.asm:2: error: syntax error
  ^---- ld a,"ab"
END_ERR

SKIP: {
    skip "Only works on Windows systems with backslash as path separator", 1 
		unless $Config{path_sep} eq ';';

    # backslash inside include filename not converted to escape sequence 
    # backslash inside defb converted to escape sequence
    z80asm_nok("", "", <<'END_ASM', <<END_ERR);
        include "a\run\new\folder"
END_ASM
$test.asm:1: error: file not found: a/run/new/folder
  ^---- include "a\\run\\new\\folder"
END_ERR
}

z80asm_ok("", "", "", <<'END_ASM', "a\run\new\folder");
		defb "a\run\new\folder"
END_ASM

unlink_testfiles;
done_testing;

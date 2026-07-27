#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Issue #3024
# The PHASE directive adds to the org, but only sometimes

# Bug case
z80asm_ok( "", "", "", <<'END', bytes(0x21,0x00,0x03, 0xC3,0x00,0x03) );
    ORG $0100

    PHASE $0300
    foo:
        ld hl, $    ;[0000] 21 00 04; should be 21 00 03
        jp foo      ;[0003] c3 00 03
    DEPHASE
END
capture_ok("z88dk-z80nm -a $test.o", <<'END');
Object  file test_t_issue_3024_t.o at $0000: Z80RMF18
  Name: test_t_issue_3024_t
  CPU:  z80 
  Section "": 6 bytes, ORG $0100
    C $0000: 21 00 03 C3 00 03
  Symbols:
    L C $0300: foo (section "") (file test_t_issue_3024_t.asm:4)
  Strings:
    S   1 = "foo"
    S   2 = "test_t_issue_3024_t.asm"
    S   3 = "test_t_issue_3024_t"
END

# non-PHASE case
z80asm_ok( "", "", "", <<'END', bytes(0x21,0x00,0x01, 0xC3,0x00,0x01) );
    ORG $0100
    foo:
        ld hl, $    ;[0000] 21 00 01
        jp foo      ;[0003] c3 00 01
END
capture_ok("z88dk-z80nm -a $test.o", <<'END');
Object  file test_t_issue_3024_t.o at $0000: Z80RMF18
  Name: test_t_issue_3024_t
  CPU:  z80 
  Section "": 6 bytes, ORG $0100
    C $0000: 21 00 00 C3 00 00
  Symbols:
    L A $0000: foo (section "") (file test_t_issue_3024_t.asm:2)
  Expressions:
    E U16   $0000 $0001 3: $ (section "") (file test_t_issue_3024_t.asm:3)
    E U16   $0003 $0004 3: foo (section "") (file test_t_issue_3024_t.asm:4)
  Strings:
    S   1 = "test_t_issue_3024_t.asm"
    S   2 = "$"
    S   3 = "foo"
    S   4 = "test_t_issue_3024_t"
END

unlink_testfiles;
done_testing;

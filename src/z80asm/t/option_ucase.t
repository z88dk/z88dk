#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("$test.asm", <<END);
SubRoutine: ret
Main:       call SubRoutine
END

# no -ucase
run_ok("z88dk-z80asm -b -m $test.asm");

check_bin_file("$test.bin", bytes(0xc9, 0xcd, 0, 0));

check_text_file("$test.map", <<END);
Main                            = \$0001 ; addr, local, , $test, , $test.asm:2
SubRoutine                      = \$0000 ; addr, local, , $test, , $test.asm:1
__head                          = \$0000 ; const, public, def, , ,
__size                          = \$0004 ; const, public, def, , ,
__tail                          = \$0004 ; const, public, def, , ,
END

capture_ok("z88dk-z80nm -a $test.o", <<'END');
Object  file test_t_option_ucase_t.o at $0000: Z80RMF18
  Name: test_t_option_ucase_t
  CPU:  z80 
  Section "": 4 bytes
    C $0000: C9 CD 00 00
  Symbols:
    L A $0001: Main (section "") (file test_t_option_ucase_t.asm:2)
    L A $0000: SubRoutine (section "") (file test_t_option_ucase_t.asm:1)
  Expressions:
    E U16   $0001 $0002 3: SubRoutine (section "") (file test_t_option_ucase_t.asm:2)
  Strings:
    S   1 = "test_t_option_ucase_t.asm"
    S   2 = "SubRoutine"
    S   3 = "Main"
    S   4 = "test_t_option_ucase_t"
END

# with -ucase
run_ok("z88dk-z80asm -b -m -ucase $test.asm");

check_bin_file("$test.bin", bytes(0xc9, 0xcd, 0, 0));

check_text_file("$test.map", <<END);
MAIN                            = \$0001 ; addr, local, , $test, , $test.asm:2
SUBROUTINE                      = \$0000 ; addr, local, , $test, , $test.asm:1
__head                          = \$0000 ; const, public, def, , ,
__size                          = \$0004 ; const, public, def, , ,
__tail                          = \$0004 ; const, public, def, , ,
END

capture_ok("z88dk-z80nm -a $test.o", <<'END');
Object  file test_t_option_ucase_t.o at $0000: Z80RMF18
  Name: test_t_option_ucase_t
  CPU:  z80 
  Section "": 4 bytes
    C $0000: C9 CD 00 00
  Symbols:
    L A $0001: MAIN (section "") (file test_t_option_ucase_t.asm:2)
    L A $0000: SUBROUTINE (section "") (file test_t_option_ucase_t.asm:1)
  Expressions:
    E U16   $0001 $0002 3: SUBROUTINE (section "") (file test_t_option_ucase_t.asm:2)
  Strings:
    S   1 = "test_t_option_ucase_t.asm"
    S   2 = "SUBROUTINE"
    S   3 = "MAIN"
    S   4 = "test_t_option_ucase_t"
END

unlink_testfiles;
done_testing;

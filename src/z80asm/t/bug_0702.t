#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# 702: UNDEFINE of a PUBLIC constant leaves the global definition
spew( "$test.asm", <<'END' );
        PUBLIC  CONSOLE_COLUMNS
        defc    CONSOLE_COLUMNS = 80
        UNDEFINE CONSOLE_COLUMNS
        defc    CONSOLE_COLUMNS = 32
        defb    CONSOLE_COLUMNS          ;; 20
END

spew( "$test.1.asm", <<'END' );
        EXTERN  CONSOLE_COLUMNS
        defb    CONSOLE_COLUMNS          ;; 20
END

run_ok("z88dk-z80asm -b $test.asm $test.1.asm");
check_bin_file( "$test.bin", bytes( 0x20, 0x20 ) );

# A local constant can still be replaced, then exported
spew( "$test.asm", <<'END' );
        defc    CONSOLE_COLUMNS = 80
        UNDEFINE CONSOLE_COLUMNS
        defc    CONSOLE_COLUMNS = 32
        PUBLIC  CONSOLE_COLUMNS
        defb    CONSOLE_COLUMNS          ;; 20
END

spew( "$test.1.asm", <<'END' );
        EXTERN  CONSOLE_COLUMNS
        defb    CONSOLE_COLUMNS          ;; 20
END

run_ok("z88dk-z80asm -b $test.asm $test.1.asm");
check_bin_file( "$test.bin", bytes( 0x20, 0x20 ) );

# UNDEFINE does not drop a public address
spew( "$test.asm", <<'END' );
label:  nop
        PUBLIC  label
        UNDEFINE label
label:  nop
END

run_nok("z88dk-z80asm -b $test.asm");

unlink_testfiles;
done_testing;

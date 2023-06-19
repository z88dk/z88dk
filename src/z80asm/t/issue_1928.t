#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/1928
# z80asm: .lis file lists incorrect bytes for REPTC macro directive

spew("$test.asm", <<END);
REPTC var, 45
defb var
ENDR

RST 38h

DEFL myversion = 23
REPTC var, myversion
defb var
ENDR

RST 38h
END

# list 
run_ok("z88dk-z80asm -b -l $test.asm");
check_bin_file("$test.bin", "45".bytes(0xff)."23".bytes(0xff));
check_text_file("$test.lis", <<END);
test_t_issue_1928.asm:
     1                          REPTC var, 45
     2                          defb var
     3  0000  3435              ENDR
     4                          
     5  0002  ff                RST 38h
     6                          
     7                          DEFL myversion = 23
     8                          REPTC var, myversion
     9                          defb var
    10  0003  3233              ENDR
    11                          
    12  0005  ff                RST 38h
    13                          
END


# verbose list
run_ok("z88dk-z80asm -b -l -v $test.asm > $null");
check_bin_file("$test.bin", "45".bytes(0xff)."23".bytes(0xff));
check_text_file("$test.lis", <<END);
test_t_issue_1928.asm:
     1                          REPTC var, 45
     2                          defb var
     3                          ENDR
        0000  34                      + defb 52
        0001  35                      + defb 53
     4                          
     5                          RST 38h
        0002  ff                      + RST 56
     6                          
     7                          DEFL myversion = 23
     8                          REPTC var, myversion
     9                          defb var
    10                          ENDR
        0003  32                      + defb 50
        0004  33                      + defb 51
    11                          
    12                          RST 38h
        0005  ff                      + RST 56
    13                          
END


unlink_testfiles;
done_testing;

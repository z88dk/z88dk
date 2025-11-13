#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("$test.inc", <<END);
#define FOO 42 /*comment*/
LD A,/*


*/FOO
LD B,2//comment
LD C,3;comment
LD D,\\
4
LD H,5 : LD L,6 \\ LD HL,7
END

spew("$test.asm", <<END);
LD BEFORE,1
#include $test.inc
LD BEFORE,2
#include "$test.inc"
LD BEFORE,3
#include <$test.inc>
LD BEFORE,4
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
LD BEFORE,1
#line 2, "$test.inc"
LD A,42



LD B,2
LD C,3
LD D, 4

LD H,5
#line 10
LD L,6
#line 10
LD HL,7
#line 3, "$test.asm"
LD BEFORE,2
#line 2, "$test.inc"
LD A,42



LD B,2
LD C,3
LD D, 4

LD H,5
#line 10
LD L,6
#line 10
LD HL,7
#line 5, "$test.asm"
LD BEFORE,3
#line 2, "$test.inc"
LD A,42



LD B,2
LD C,3
LD D, 4

LD H,5
#line 10
LD L,6
#line 10
LD HL,7
#line 7, "$test.asm"
LD BEFORE,4
END

unlink_testfiles if Test::More->builder->is_passing;
done_testing;

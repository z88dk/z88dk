#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("$test.1.inc", <<END);
LD A,1
END

spew("$test.2.inc", <<END);
LD A,2
#include "$test.3.inc";
END

spew("$test.3.inc", <<END);
LD A,3
#include "$test.4.inc";
END

spew("$test.4.inc", <<END);
LD A,4
END

spew("$test.asm", <<END);
#include "$test.1.inc"
#include "$test.2.inc"
LD A,5
END

capture_ok("z88dk-z80asm -v -E -MD $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
Generating dependency file: $test.d
END

check_text_file("$test.i", <<END);
#line 1, "$test.1.inc"
LD A,1
#line 1, "$test.2.inc"
LD A,2
#line 1, "$test.3.inc"
LD A,3
#line 1, "$test.4.inc"
LD A,4
#line 3, "$test.asm"
LD A,5
END

check_text_file("$test.d", <<END);
$test.o: $test.asm $test.1.inc $test.2.inc $test.3.inc $test.4.inc
END

unlink_testfiles if Test::More->builder->is_passing;
done_testing;

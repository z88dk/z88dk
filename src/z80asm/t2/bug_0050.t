#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# BUG_0050: Making a library with more than 64K and -d option fails 
# - max. code size reached

# assemble only
path("${test}1.asm")->spew(<<END);
        defs 65000
END
path("${test}2.asm")->spew(<<END);
        defs 65000
END
capture_ok("./z88dk-z80asm ${test}1.asm ${test}2.asm", "");
unlink "${test}1.asm", "${test}2.asm";

# make library
capture_ok("./z88dk-z80asm -d -x${test}.lib ${test}1 ${test}2", "");
ok -f "${test}.lib";

unlink_testfiles;
done_testing;

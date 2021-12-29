#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

capture_nok("./z88dk-z80asm -float", <<END);
Error: invalid float format
END

capture_nok("./z88dk-z80asm -float=xx", <<END);
Error: invalid float format
END

unlink_testfiles;
done_testing;

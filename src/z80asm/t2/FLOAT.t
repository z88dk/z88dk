#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

capture_nok("./z88dk-z80asm -float", <<END);
Error: invalid float format
Available float formats: z80 ieee mbfs mbf40 mbf64 z88 ieee16 am9511 math48 genmath zx zx81
END

capture_nok("./z88dk-z80asm -float=xx", <<END);
Error: invalid float format
Available float formats: z80 ieee mbfs mbf40 mbf64 z88 ieee16 am9511 math48 genmath zx zx81
END

unlink_testfiles;
done_testing;

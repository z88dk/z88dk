#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

unlink_testfiles;
capture_nok("z88dk-z80asm -v=x", <<END);
error: illegal option: -v=x
END

unlink_testfiles;
capture_nok("z88dk-z80asm -verbose=x", <<END);
error: illegal option: -verbose=x
END

unlink_testfiles;
capture_nok("z88dk-z80asm -nv", <<END);
error: illegal option: -nv
END

unlink_testfiles;
done_testing;

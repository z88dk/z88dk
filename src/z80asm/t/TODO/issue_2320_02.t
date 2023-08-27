#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


# -M* and -d are incompatible

unlink_testfiles;
spew("$test.asm", "nop");
capture_nok("z88dk-z80asm -d -m* -x$test.lib $test", <<'END');
error: cannot build libraries with -m* and -d
END


unlink_testfiles;
done_testing;

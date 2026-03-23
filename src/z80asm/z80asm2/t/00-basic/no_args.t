BEGIN { use lib 't'; require 'testlib.pl'; }

# without options output just copyright information
capture_ok("z88dk-z80asm", "t/00-basic/expected/no_args.txt");

unlink_testfiles;
done_testing;

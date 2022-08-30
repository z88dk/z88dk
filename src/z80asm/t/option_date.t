#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# -d

# first compiles; second skips
unlink_testfiles;

spew("${test}.asm", <<END);
	nop
END

capture_ok("z88dk-z80asm -d ${test}.asm", "");
ok -f "${test}.o", "object file";

my $date_obj = -M "${test}.o";

# now skips compile
sleep(1);		# make sure our obj is older

capture_ok("z88dk-z80asm -d ${test}.asm", "");
ok -f "${test}.o", "object file";

ok abs((-M "${test}.o") - $date_obj) < 0.001, "same object";

# touch source
sleep(1);		# make sure our obj is older

spew("${test}.asm", <<END);
	nop
END

capture_ok("z88dk-z80asm -d ${test}.asm", "");
ok -f "${test}.o", "object file";

ok abs((-M "${test}.o") - $date_obj) > 0, "new object";

# remove source, give -d -> uses existing object - with extensiom
unlink "${test}.asm";

$date_obj = -M "${test}.o";

capture_ok("z88dk-z80asm -d ${test}.asm", "");
ok -f "${test}.o", "object file";

is -M "${test}.o", $date_obj, "same object";

# remove source, give -d -> uses existing object - without extensiom
unlink "${test}.asm";

$date_obj = -M "${test}.o";

capture_ok("z88dk-z80asm -d ${test}", "");
ok -f "${test}.o", "object file";

is -M "${test}.o", $date_obj, "same object";





unlink_testfiles;
done_testing;

#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# no extension
#------------------------------------------------------------------------------

unlink_testfiles;

spew("${test}_lib.asm", <<'END');
		public sub1
sub1:	ret
END

capture_ok("z88dk-z80asm -x${test}_lib ${test}_lib.asm", "");
ok -f "${test}_lib.lib";

spew("${test}.asm", <<'END');
		extern sub1
		call sub1
END

capture_ok("z88dk-z80asm -b -l${test}_lib ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xcd, 3, 0, 0xc9));

#------------------------------------------------------------------------------
# .lib extension
#------------------------------------------------------------------------------

unlink_testfiles;

spew("${test}_lib.asm", <<'END');
		public sub1
sub1:	ret
END

capture_ok("z88dk-z80asm -x${test}_lib.lib ${test}_lib.asm", "");
ok -f "${test}_lib.lib";

spew("${test}.asm", <<'END');
		extern sub1
		call sub1
END

capture_ok("z88dk-z80asm -b -l${test}_lib.lib ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xcd, 3, 0, 0xc9));

#------------------------------------------------------------------------------
# .a extension
#------------------------------------------------------------------------------

unlink_testfiles;

spew("${test}_lib.asm", <<'END');
		public sub1
sub1:	ret
END

capture_ok("z88dk-z80asm -x${test}_lib.a ${test}_lib.asm", "");
ok -f "${test}_lib.a";

spew("${test}.asm", <<'END');
		extern sub1
		call sub1
END

capture_ok("z88dk-z80asm -b -l${test}_lib.a ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xcd, 3, 0, 0xc9));

unlink_testfiles;
done_testing;

#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("${test}.asm", <<'END');
	subroutine1:
	  ld b,2
	@next:
	  ; do something
	  djnz @next
	ret

	subroutine2:
	  ld b,2
	@next:
	  ; do something
	  djnz @next
	ret
	
	subroutine3:
	  cp 2
	  jr nz, @next
	  ; do something
	@next:
	ret
	
	main:
	  call subroutine3@next
	ret
END

capture_ok("z88dk-z80asm -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0x06, 2,
									0x10, -2,
									0xc9,
									0x06, 2,
									0x10, -2,
									0xc9,
									0xfe, 2,
									0x20, 0,
									0xc9,
									0xcd, 0x0e, 0x00,
									0xc9));


spew("${test}.asm", <<'END');
	@next:
	  ; do something
	  djnz @next
END

capture_nok("z88dk-z80asm -b ${test}.asm", <<END);
$test.asm:1: error: local label without normal label before it: \@next
  ^---- \@next:
$test.asm:3: error: local label without normal label before it: \@next
  ^---- djnz \@next
END


spew("${test}.asm", <<'END');
	subroutine1:
	@next:
	  ; do something
	  djnz @prev
END

capture_nok("z88dk-z80asm -b ${test}.asm", <<END);
$test.asm:4: error: undefined symbol: subroutine1\@prev
  ^---- subroutine1\@prev
END


spew("${test}.asm", <<'END');
	subroutine1:
	@next:
	  ; do something
	  djnz @next
	@next:
END

capture_nok("z88dk-z80asm -b ${test}.asm", <<END);
$test.asm:5: error: duplicate definition: subroutine1\@next
  ^---- \@next:
END


spew("${test}.asm", <<'END');
	  djnz @next
END

capture_nok("z88dk-z80asm -b ${test}.asm", <<END);
$test.asm:1: error: local label without normal label before it: \@next
  ^---- djnz \@next
$test.asm:1: error: undefined symbol: \@next
  ^---- \@next
END


spew("${test}.asm", <<'END');
	hello@world@earth:
END


unlink_testfiles;
done_testing;

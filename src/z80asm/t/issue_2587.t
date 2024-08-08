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
check_bin_file("${test}.bin", bytes());


spew("${test}.asm", <<'END');
	@next:
	  ; do something
	  djnz @next
END

capture_nok("z88dk-z80asm -b ${test}.asm", <<END);
END


spew("${test}.asm", <<'END');
	subroutine1:
	@next:
	  ; do something
	  djnz @prev
END

capture_nok("z88dk-z80asm -b ${test}.asm", <<END);
END


spew("${test}.asm", <<'END');
	  djnz @next
END

capture_nok("z88dk-z80asm -b ${test}.asm", <<END);
END


spew("${test}.asm", <<'END');
	hello@world:
END

capture_nok("z88dk-z80asm -b ${test}.asm", <<END);
END

unlink_testfiles;
done_testing;

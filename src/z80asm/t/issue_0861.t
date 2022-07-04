#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/861
# allow "jr $+offset" to parse code for other assemblers

z80asm_ok("", "", "", <<'END', bytes(0x18, 2, 0x18, 0, 0x18, -2, 0x18, -4));
		jr l1
		jr l1
l1:		jr l1
		jr l1
END

z80asm_ok("", "", "", <<'END', bytes(0x18, 2, 0x18, 0, 0x18, -2, 0x18, -4));
		jr ASMPC+4
		jr ASMPC+2
l1:		jr ASMPC
		jr ASMPC-2
END

z80asm_ok("", "", "", <<'END', bytes(0x18, 2, 0x18, 0, 0x18, -2, 0x18, -4));
		jr $+4
		jr $+2
l1:		jr $
		jr $-2
END

unlink_testfiles;
done_testing;

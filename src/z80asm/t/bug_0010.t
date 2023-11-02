#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0010 : heap corruption when reaching MAXCODESIZE
# raise HEAP CORRUPTION DETECTED in MSVC

z80asm_ok("", "", "", <<END, bytes((0x55) x 65536));
        defs 65536, 0x55
END


z80asm_ok("", "", "", <<END, bytes((0x55) x 65534, 0x3e, 0x55));
        defs 65534, 0x55
        ld a, 0x55
END

z80asm_nok("", "", <<END, <<END);
        defs 65535, 0x55
        ld a, 0x55
END
${test}.asm:2: error: segment overflow
  ^---- ld a, 0x55
      ^---- ld a,85
END


z80asm_ok("", "", "", <<END, bytes((0x55) x 65533, 0x01, 0x55, 0x55));
        defs 65533, 0x55
        ld bc, 0x5555
END

z80asm_nok("", "", <<END, <<END);
        defs 65534, 0x55
        ld bc, 0x5555
END
${test}.asm:2: error: segment overflow
  ^---- ld bc, 0x5555
      ^---- ld bc,21845
END


z80asm_ok("", "", "", <<END, bytes((0x55) x 65536));
        defs 65532, 0x55
        defq 0x55555555
END

z80asm_nok("", "", <<END, <<END);
        defs 65533, 0x55
        defq 0x55555555
END
${test}.asm:2: error: segment overflow
  ^---- defq 0x55555555
      ^---- defq 1431655765
END

unlink_testfiles;
done_testing;

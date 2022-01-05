#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# BUG_0010 : heap corruption when reaching MAXCODESIZE
# raise HEAP CORRUPTION DETECTED in MSVC

z80asm_ok("", "", "", <<END, bytes((0xaa) x 65536));
        defs 65536, 0xaa
END


z80asm_ok("", "", "", <<END, bytes((0xaa) x 65534, 0x3e, 0xaa));
        defs 65534, 0xaa
        ld a, 0xaa
END

z80asm_nok("", "", <<END, <<END);
        defs 65535, 0xaa
        ld a, 0xaa
END
${test}.asm:2: error: segment overflow
  ^---- ld a, 0xaa
      ^---- ld a,170
END


z80asm_ok("", "", "", <<END, bytes((0xaa) x 65533, 0x01, 0xaa, 0xaa));
        defs 65533, 0xaa
        ld bc, 0xaaaa
END

z80asm_nok("", "", <<END, <<END);
        defs 65534, 0xaa
        ld bc, 0xaaaa
END
${test}.asm:2: error: segment overflow
  ^---- ld bc, 0xaaaa
      ^---- ld bc,43690
END


z80asm_ok("", "", "", <<END, bytes((0xaa) x 65536));
        defs 65532, 0xaa
        defq 0xaaaaaaaa
END

z80asm_nok("", "", <<END, <<END);
        defs 65533, 0xaa
        defq 0xaaaaaaaa
END
${test}.asm:2: error: segment overflow
  ^---- defq 0xaaaaaaaa
      ^---- defq-1431655766
END

unlink_testfiles;
done_testing;

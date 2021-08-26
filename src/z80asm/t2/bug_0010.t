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
Error at file '${test}.asm' line 2: max. code size of 65536 bytes reached
END


z80asm_ok("", "", "", <<END, bytes((0xaa) x 65533, 0x01, 0xaa, 0xaa));
        defs 65533, 0xaa
        ld bc, 0xaaaa
END

z80asm_nok("", "", <<END, <<END);
        defs 65534, 0xaa
        ld bc, 0xaaaa
END
Error at file '${test}.asm' line 2: max. code size of 65536 bytes reached
END


z80asm_ok("", "", "", <<END, bytes((0xaa) x 65536));
        defs 65532, 0xaa
        defq 0xaaaaaaaa
END

z80asm_nok("", "", <<END, <<END);
        defs 65533, 0xaa
        defq 0xaaaaaaaa
END
Error at file '${test}.asm' line 2: max. code size of 65536 bytes reached
END

unlink_testfiles;
done_testing;

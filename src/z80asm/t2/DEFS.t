#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# test DEFS

for my $filler (0, 1, 0xff) {
    my $filler_options = $filler==0 ? "" : "-f$filler";
    z80asm_ok("-b $filler_options", "", "",
    '   DEFB    123             ' => bytes(123),
    '   DEFS    0               ' => '',
    '   DEFB    123             ' => bytes(123),
    '   DEFS    1               ' => bytes(($filler) x 1),
    '   DEFB    123             ' => bytes(123),
    '   DEFS    2               ' => bytes(($filler) x 2),
    '   DEFB    123             ' => bytes(123),
    '   DS      3               ' => bytes(($filler) x 3),
    '   DEFB    123             ' => bytes(123),
    '   DS      4               ' => bytes(($filler) x 4),
    '   DEFB    123             ' => bytes(123),
        
    '   DEFS    2,-128          ' => bytes(0x80, 0x80),
    '   DEFB    123             ' => bytes(123),
    '   DEFS    2,-127          ' => bytes(0x81, 0x81),
    '   DEFB    123             ' => bytes(123),
    '   DS      2,255           ' => bytes(0xff, 0xff),
    '   DEFB    123             ' => bytes(123),
        
    '   DEFS    10,""           ' => bytes(($filler) x 10),
    '   DEFB    123             ' => bytes(123),
    '   DEFS    10,"hello"      ' => 'hello'.bytes(($filler) x 5),
    '   DEFB    123             ' => bytes(123),
    '   DS      5,"hello"       ' => 'hello',
    '   DEFB    123             ' => bytes(123),
    
    '   IF 0                    ' => '',       
    '     DS 4                  ' => '',       
    '   ELSE                    ' => '',       
    '     DS 4                  ' => bytes(($filler) x 4),
    '   ENDIF                   ' => '',       
    );
}


z80asm_nok("", "", <<END, <<END);
        defs
END
Error at file '${test}.asm' line 1: syntax error
END

z80asm_nok("", "", <<END, <<END);
        ds 4, "hello"
END
Error at file '${test}.asm' line 1: string longer than reserved space
END

z80asm_nok("", "", <<END, <<END);
        extern ZERO
        defs ZERO, 0
END
Error at file '${test}.asm' line 2: expected constant expression
END

z80asm_nok("", "", <<END, <<END);
        extern ZERO
        defs 0, ZERO
END
Error at file '${test}.asm' line 2: expected constant expression
END

z80asm_nok("", "", <<END, <<END);
        defs undefined, 0
END
Error at file '${test}.asm' line 1: symbol 'undefined' not defined
Error at file '${test}.asm' line 1: expected constant expression
END

z80asm_nok("", "", <<END, <<END);
        defs 0, undefined
END
Error at file '${test}.asm' line 1: symbol 'undefined' not defined
Error at file '${test}.asm' line 1: expected constant expression
END

for my $size (-1, 0x10001) {
    z80asm_nok("", "", <<END, <<END);
        defs $size
        defs $size, 0xff
        defs $size, "hello"
END
Error at file '${test}.asm' line 1: integer '$size' out of range
Error at file '${test}.asm' line 2: integer '$size' out of range
Error at file '${test}.asm' line 3: integer '$size' out of range
END
}

for my $filler (-129, 0x100) {
    z80asm_nok("", "", <<END, <<END);
        defs 2, $filler
END
Error at file '${test}.asm' line 1: integer '$filler' out of range
END
}


z80asm_ok("", "", "", 
    '   defs 65536              ' => bytes((0) x 65536));

z80asm_ok("", "", "", 
    '   defb 0                  ' => bytes(0),
    '   defs 65535              ' => bytes((0) x 65535));


z80asm_nok("-b -f-1", "", <<END, <<END);
        nop
END
Error: invalid filler value: -1
END

z80asm_nok("-b -f256", "", <<END, <<END);
        nop
END
Error: invalid filler value: 256
END


unlink_testfiles;
done_testing;

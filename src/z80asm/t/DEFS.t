#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

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
    );
}


z80asm_nok("", "", <<END, <<END);
        defs
END
$test.asm:1: error: syntax error
  ^---- defs
END

z80asm_nok("", "", <<END, <<END);
        ds 4, "hello"
END
$test.asm:1: error: string longer than reserved space
  ^---- ds 4, "hello"
END

z80asm_nok("", "", <<END, <<END);
        extern ZERO
        defs ZERO, 0
END
$test.asm:2: error: constant expression expected
  ^---- defs ZERO, 0
END

z80asm_nok("", "", <<END, <<END);
        extern ZERO
        defs 0, ZERO
END
$test.asm:2: error: constant expression expected
  ^---- defs 0, ZERO
END

z80asm_nok("", "", <<END, <<END);
        defs undefined, 0
END
$test.asm:1: error: undefined symbol: undefined
  ^---- defs undefined, 0
$test.asm:1: error: constant expression expected
  ^---- defs undefined, 0
END

z80asm_nok("", "", <<END, <<END);
        defs 0, undefined
END
$test.asm:1: error: undefined symbol: undefined
  ^---- defs 0, undefined
$test.asm:1: error: constant expression expected
  ^---- defs 0, undefined
END

z80asm_nok("", "", <<END, <<END);
	defs -1
	defs -1, 0xff
	defs -1, "hello"
END
$test.asm:1: error: integer range: -1
  ^---- defs -1
$test.asm:2: error: integer range: -1
  ^---- defs -1, 0xff
      ^---- defs-1,255
$test.asm:3: error: integer range: -1
  ^---- defs -1, "hello"
END

z80asm_nok("", "", <<END, <<END);
	defs 65537
	defs 65537, 0xff
	defs 65537, "hello"
END
$test.asm:1: error: integer range: 0x10001
  ^---- defs 65537
$test.asm:2: error: integer range: 0x10001
  ^---- defs 65537, 0xff
      ^---- defs 65537,255
$test.asm:3: error: integer range: 0x10001
  ^---- defs 65537, "hello"
END

z80asm_nok("", "", <<END, <<END);
	defs 2, -129
END
$test.asm:1: error: integer range: -129
  ^---- defs 2, -129
END

z80asm_nok("", "", <<END, <<END);
	defs 2, 0x100
END
$test.asm:1: error: integer range: 0x100
  ^---- defs 2, 0x100
      ^---- defs 2,256
END

z80asm_ok("", "", "", 
    '   defs 65536              ' => bytes((0) x 65536));

z80asm_ok("", "", "", 
    '   defb 0                  ' => bytes(0),
    '   defs 65535              ' => bytes((0) x 65535));

z80asm_nok("", "", <<END, <<END);
        defs 65535
		defw 0
END
$test.asm:2: error: segment overflow
  ^---- defw 0
END

z80asm_nok("-b -f-1", "", <<END, <<END);
        nop
END
error: invalid filler (-f) option: -1
END

z80asm_nok("-b -f256", "", <<END, <<END);
        nop
END
error: invalid filler (-f) option: 256
END

unlink_testfiles;
done_testing;

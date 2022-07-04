#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Z88DK specific opcodes
z80asm_ok("", "", "", 
'		call_oz 1		', bytes(0xe7, 1),
'		call_oz 255		', bytes(0xe7, 255),
'		call_oz 256		', bytes(0xe7).words(256),
'		call_oz 65535	', bytes(0xe7).words(65535));

z80asm_nok("", "", <<END, <<END);
		call_oz 0
END
$test.asm:1: error: integer range: 0
  ^---- call_oz 0
END


z80asm_ok("", "", "", 
'		call_pkg 0		', bytes(0xcf).words(0),
'		call_pkg 1		', bytes(0xcf).words(1),
'		call_pkg 65535	', bytes(0xcf).words(65535));

z80asm_nok("", "", <<END, <<END);
		call_pkg -1
END
$test.asm:1: error: integer range: -1
  ^---- call_pkg -1
END


z80asm_ok("", "", "", 
'		fpp 1		', bytes(0xdf, 1),
'		fpp 254		', bytes(0xdf, 254));

z80asm_nok("", "", <<END, <<END);
		fpp 0
		fpp 255
		fpp 256
END
$test.asm:1: error: integer range: 0
  ^---- fpp 0
$test.asm:2: error: integer range: 0xff
  ^---- fpp 255
$test.asm:3: error: integer range: 0x100
  ^---- fpp 256
END


unlink_testfiles;
done_testing;

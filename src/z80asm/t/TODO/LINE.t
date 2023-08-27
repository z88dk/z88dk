#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		line 10
		ld
END_ASM
$test.asm:10: error: syntax error
  ^---- ld
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		line 10
		nop
		ld
END_ASM
$test.asm:11: error: syntax error
  ^---- ld
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		line 10, "hello.asm"
		nop
		ld
END_ASM
hello.asm:11: error: syntax error
  ^---- ld
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		c_line 10
		ld
END_ASM
$test.asm:10: error: syntax error
  ^---- ld
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		c_line 10
		nop
		ld
END_ASM
$test.asm:10: error: syntax error
  ^---- ld
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		c_line 10, "test.c"
		nop
		ld
END_ASM
test.c:10: error: syntax error
  ^---- ld
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		extern THE_LINE
		line THE_LINE
		line THE_LINE, "file1.asm"
END_ASM
$test.asm:2: error: syntax error
  ^---- line THE_LINE
$test.asm:3: error: syntax error
  ^---- line THE_LINE, "file1.asm"
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		extern THE_LINE
		c_line THE_LINE
		c_line THE_LINE, "file1.asm"
END_ASM
$test.asm:2: error: syntax error
  ^---- c_line THE_LINE
$test.asm:3: error: syntax error
  ^---- c_line THE_LINE, "file1.asm"
END_ERR

unlink_testfiles;
done_testing;

#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test --debug info in map file

use strict;
use warnings;
use v5.10;
use Test::More;
require './t/testlib.pl';

spew("test1.asm", <<END);
	public func

func:
	ld a, 1
	ld b, 3
	add a, b
	ret
END

spew("test.asm", <<END);
	extern func

main:
	call func
	ret
END

run("z80asm -b --debug test.asm test1.asm");
check_text_file("test.map", <<'END');
main                            = $0000 ; addr, local, , test, , test.asm:3
__ASM_LINE_3                    = $0000 ; addr, local, , test, , test.asm:3
__ASM_LINE_4                    = $0000 ; addr, local, , test, , test.asm:4
__ASM_LINE_5                    = $0003 ; addr, local, , test, , test.asm:5
__ASM_LINE_3                    = $0004 ; addr, local, , test1, , test1.asm:3
__ASM_LINE_4                    = $0004 ; addr, local, , test1, , test1.asm:4
__ASM_LINE_5                    = $0006 ; addr, local, , test1, , test1.asm:5
__ASM_LINE_6                    = $0008 ; addr, local, , test1, , test1.asm:6
__ASM_LINE_7                    = $0009 ; addr, local, , test1, , test1.asm:7
func                            = $0004 ; addr, public, , test1, , test1.asm:3
__head                          = $0000 ; const, public, def, , ,
__tail                          = $000A ; const, public, def, , ,
__size                          = $000A ; const, public, def, , ,
END

unlink_testfiles();
done_testing();

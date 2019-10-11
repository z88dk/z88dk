#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test DEFS

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
z80asm(<<'END');
ds:	defs 0								
	defs 1								
	defs 2								
	defs 3								
	defs 4								
	
	defs 2,-128							
	defs 2,-127							
	defs 2,0							
	defs 2,255							
	
	if 0								
		defs 2,0						
	else								
		defs 2,2						
	endif								
END
check_bin_file("test.bin", pack("C*", 
								0, 
								0,0, 
								0,0,0, 
								0,0,0,0, 
								0x80,0x80, 
								0x81,0x81, 
								0,0, 
								0xFF,0xFF, 
								2,2));

unlink_testfiles();
z80asm(<<'END', "", 1, "", <<'ERR');
	extern ZERO
	defs ZERO,0
	defs undefined,0
	defs 0,ZERO
	defs 0,undefined
	defs -1
	defs 65537
	defs 2,-129
	defs 2,256
END
Error at file 'test.asm' line 2: expected constant expression
Error at file 'test.asm' line 3: symbol 'undefined' not defined
Error at file 'test.asm' line 3: expected constant expression
Error at file 'test.asm' line 4: expected constant expression
Error at file 'test.asm' line 5: symbol 'undefined' not defined
Error at file 'test.asm' line 5: expected constant expression
Error at file 'test.asm' line 6: integer '-1' out of range
Error at file 'test.asm' line 7: integer '65537' out of range
Error at file 'test.asm' line 8: integer '-129' out of range
Error at file 'test.asm' line 9: integer '256' out of range
ERR

unlink_testfiles();
done_testing();

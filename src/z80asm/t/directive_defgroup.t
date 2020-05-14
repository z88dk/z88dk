#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test defgroup

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

# defgroup without end-comma
unlink_testfiles();
z80asm(<<'END');
	defgroup 							
	{ 									
		f0, f1  						
		f2, f3,  						
		f10 = 10,  						
		f11,  							
		f20 = 20, f21					
		rl					; opcode can be used as constant
	} 									
	defb f0,f1,f2,f3,f10,f11,f20,f21,rl	
END
check_bin_file("test.bin", pack("C*", 0,1,2,3,10,11,20,21,22));

# defgroup with end-comma
unlink_testfiles();
z80asm(<<'END');
	defgroup 							
	{ 									
		dg1, dg2 = 3					
		dg3 = 7,						
	}			  						
	defb dg1,dg2,dg3					
END
check_bin_file("test.bin", pack("C*", 0,3,7));

# defgroup with conditional assembly
unlink_testfiles();
z80asm(<<'END');
	if 1								
		defgroup 						
		{ 								
			ff = 1						
		}								
	else								
		defgroup 						
		{								
			ff = 2						
		}								
	endif								
	if 0								
		defgroup 						
		{ 								
			fg = 1						
		}								
	else								
		defgroup 						
		{								
			fg = 2						
		}								
	endif								
	defb ff, fg							
END
check_bin_file("test.bin", pack("C*", 1,2));

# separate defgroup start from zero
unlink_testfiles();
z80asm(<<'END');
	defgroup { 									
		dg1, dg2,
	}			  						
	defgroup { 									
		dg3, dg4
	}			  						
	defb dg1,dg2,dg3,dg4
END
check_bin_file("test.bin", pack("C*", 0,1,0,1));

# defgroup with link-time constants
unlink_testfiles();
z80asm(<<'END', "", 1, "", <<'ERR');
	extern START
	defgroup { 									
		dg1 = START
		dg2 = undefined
	}			  						
END
Error at file 'test.asm' line 3: expected constant expression
Error at file 'test.asm' line 4: symbol 'undefined' not defined
Error at file 'test.asm' line 4: expected constant expression
ERR

# range errors
unlink_testfiles();
z80asm(<<'END', "", 1, "", <<'ERR');
	defgroup {
		dg1 = 65535
		dg2	= 65536					;; error: integer '65536' out of range
		dg3 = -32768
		dg4 = -32769				;; error: integer '-32769' out of range
	}
END
Error at file 'test.asm' line 3: integer '65536' out of range
Error at file 'test.asm' line 5: integer '-32769' out of range
ERR

# {} block
unlink_testfiles();
z80asm(<<'END', "", 1, "", <<'ERR');
	defgroup 
END
Error at file 'test.asm' line 2: missing {} block
ERR

unlink_testfiles();
z80asm(<<'END', "", 1, "", <<'ERR');
	defgroup  {
END
Error at file 'test.asm' line 2: {} block not closed
ERR

# BUG_0032 : DEFGROUP ignores name after assignment
unlink_testfiles();
z80asm(<<'END', "-b", 0, "", "");
		defgroup
		{
			f10 = 10, f11
		}
		defb f10, f11
END
check_bin_file("test.bin", pack("C*", 0x0A, 0x0B));

unlink_testfiles();
done_testing();

#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# defgroup without end-comma
z80asm_ok("", "", "", <<END,
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
	bytes(0,1,2,3,10,11,20,21,22));

# defgroup with end-comma
z80asm_ok("", "", "", <<END,
	defgroup 							
	{ 									
		dg1, dg2 = 3					
		dg3 = 7,						
	}			  						
	defb dg1,dg2,dg3					
END
	bytes(0,3,7));

# defgroup with conditional assembly
z80asm_ok("", "", "", <<END,
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
	bytes(1,2));

# separate defgroup start from zero
z80asm_ok("", "", "", <<END,
	defgroup { 									
		dg1, dg2,
	}			  						
	defgroup { 									
		dg3, dg4
	}			  						
	defb dg1,dg2,dg3,dg4
END
	bytes(0,1,0,1));

# defgroup with link-time constants
z80asm_nok("", "", <<END, <<END);
	extern START
	defgroup { 									
		dg1 = START
		dg2 = undefined
	}			  						
END
$test.asm:3: error: constant expression expected
  ^---- dg1 = START
$test.asm:4: error: undefined symbol: undefined
  ^---- dg2 = undefined
$test.asm:4: error: constant expression expected
  ^---- dg2 = undefined
END

# range errors
z80asm_nok("", "", <<END, <<END);
	defgroup {
		dg1 = 65535
		dg2	= 65536
		dg3 = -32768
		dg4 = -32769
	}
END
$test.asm:3: error: integer range: 0x10000
  ^---- dg2 = 65536
$test.asm:5: error: integer range: -32769
  ^---- dg4 = -32769
END

# {} block
z80asm_nok("", "", <<END, <<END);
	defgroup 
END
$test.asm:2: error: missing {} block
END

z80asm_nok("", "", <<END, <<END);
	defgroup {
END
$test.asm:2: error: {} block not closed
END

unlink_testfiles;
done_testing;

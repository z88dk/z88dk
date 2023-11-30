#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/603
# z80asm: Handling of defvars and defgroup

z80asm_ok("", "", "", <<END, bytes(10..19));
		defgroup { f10=10,f11=11 }
		defgroup { f12=12,f13=13
		}
		defgroup { f14=14,
			f15=15 }
		defgroup { 
			f16=16,f17=17 }
		defgroup 
		{   f18=18,f19=19 }
		defb f10,f11,f12,f13,f14,f15,f16,f17,f18,f19
END

z80asm_ok("", "", "", <<END, bytes(1..6));
	defvars 1 { v1 ds.b 1 }
	defvars 2 { v2 ds.b 1
	}
	defvars 3 { 
			v3 ds.b 1 }
	defvars 4 
	{		v4 ds.b 1 }
	defvars 5
	{		v5 ds.b 1 
	}
	defvars 6
	{		
			v6 ds.b 1 
	}
	defb v1,v2,v3,v4,v5,v6
END

unlink_testfiles;
done_testing;

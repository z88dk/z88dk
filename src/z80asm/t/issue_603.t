#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/603
# z80asm: Handling of defvars and defgroup

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
z80asm(<<'END', "-b", 0, "", "");
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
check_bin_file("test.bin", pack("C*", 10..19));

unlink_testfiles();
z80asm(<<'END');
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
check_bin_file("test.bin", pack("C*", 1..6));

unlink_testfiles();
done_testing();

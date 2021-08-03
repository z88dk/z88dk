#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test defvars

use Modern::Perl;
use Test::More;
require './t/testlib.pl';


unlink_testfiles();
z80asm(<<'END');
	defc defvars_base = 0x80			;;
	defvars defvars_base				;;
										;;
	{									;;
		df1 ds.b 4						;; ; df1 = 0x80
		df2 ds.w 2						;; ; df2 = 0x80 + 4 = 0x84
		df3 ds.p 2						;; ; df3 = 0x84 + 2*2 = 0x88
		df4 ds.q 2						;; ; df4 = 0x88 + 2*3 = 0x8E
		df5 							;; ; df5 = 0x8E + 2*4 = 0x96
		rr								;; ; opcode can be used as constant
										;;
	}									;;
	defb df1, df2, df3, df4, df5, rr	;; defb 80h, 84h, 88h, 8Eh, 96h, 96h
	
	defvars 0 {							;;
		df6 ds.b 1						;; ; df6 = 0
		df7 ds.b 1						;; ; df7 = 1
		df8 							;; ; df8 = 2
	}									;;
	defb df6, df7, df8					;; defb 0, 1, 2
	
	defvars -1 ; continue after df5		;;
	{									;;
		df9  ds.b 1						;; ; df9 = 0x96
		df10 ds.b 1						;; ; df10 = 0x97
		df11							;; ; df11 = 0x98
		df12							;; ; df12 = 0x98
	}									;;
	defb df9, df10, df11, df12			;; defb 96h, 97h, 98h, 98h

	defvars 0 {							;;
		df13 ds.b 1						;; ; df13 = 0
		df14 ds.b 1						;; ; df14 = 1
		df15 							;; ; df15 = 2
	}									;;
	defb df13, df14, df15				;; defb 0, 1, 2
	
	defvars -1 ; continue after df12	;;
	{									;;
		df16 ds.b 1						;; ; df16 = 0x98
		df17 ds.b 1						;; ; df17 = 0x99
		df18 ds.b 0						;; ; df18 = 0x9A
		df19							;; ; df19 = 0x9A
	}									;;
	defb df16, df17, df18, df19			;; defb 98h, 99h, 9Ah, 9Ah

	; check with conditional assembly
	if 1								;;
		defvars 0 						;;
		{								;;
			df20 ds.b 1					;;
			df21						;;
		}								;;
	else								;;
		defvars 0						;;
		{								;;
			df20 ds.w 1					;;
			df21						;;
		}								;;
	endif								;;
	defb df20, df21						;; defb 0, 1
	
	if 0								;;
		defvars 0 						;;
		{								;;
			df30 ds.b 1					;;
			df31						;;
		}								;;
	else								;;
		defvars 0						;;
		{								;;
			df30 ds.w 1					;;
			df31						;;
		}								;;
	endif								;;
	defb df30, df31						;; defb 0, 2
END
check_bin_file("test.bin", pack("C*", 
			0x80, 0x84, 0x88, 0x8E, 0x96, 0x96,
			0, 1, 2,
			0x96, 0x97, 0x98, 0x98,
			0, 1, 2, 
			0x98, 0x99, 0x9A, 0x9A,
			0, 1,
			0, 2,
));


unlink_testfiles();
spew("test.asm", "
	defc defvars_base = 0x80			
	defvars defvars_base				
										
	{									
		df1 ds.b 4;						; df1 = 0x80
		df2 ds.w 2;						; df2 = 0x80 + 4 = 0x84
		df3 ds.p 2;						; df3 = 0x84 + 2*2 = 0x88
		df4 ds.q 2;						; df4 = 0x88 + 2*3 = 0x8E
		df5 							; df5 = 0x8E + 2*4 = 0x96
										
	}									
	defb df1, df2, df3, df4, df5		;; 80 84 88 8E 96
");
spew("test1.asm", "
	defvars -1 ; continue after df5		
	{									
		df9  ds.b 1						; df9 = 0x96
		df10 ds.b 1						; df10 = 0x97
		df11							; df11 = 0x98
		df12							; df12 = 0x98
	}									
	defb df9, df10, df11, df12			;; 96 97 98 98
");
spew("test2.asm", "
	defvars -1 ; continue after df12	
	{									
		df16 ds.b 1						; df16 = 0x98
		df17 ds.b 1						; df17 = 0x99
		df18							; df18 = 0x9A
	}									
	defb df16, df17, df18				;; 98 99 9A
");
run("./z88dk-z80asm -b test.asm test1.asm test2.asm");
check_bin_file("test.bin", "\x80\x84\x88\x8E\x96\x96\x97\x98\x98\x98\x99\x9A");


unlink_testfiles();
z80asm("
	defvars -1 ; continue from 0
	{
		df1	ds.b 1
	}
	defb df1							;; 00
");
check_bin_file("test.bin", "\x00");


unlink_testfiles();
spew("test.asm", "
	defvars 0
	{
		df1	ds.q 10
		df2	ds.q 16383					;; error: integer '65572' out of range
	}
");
run("./z88dk-z80asm -b test.asm", 1, "", <<END);
Error at file 'test.asm' line 5: integer '65572' out of range
END


unlink_testfiles();
spew("test.asm", "
	defvars 0
	{
		df2	ds.q 16384					;; error: integer '65536' out of range
	}
");
run("./z88dk-z80asm -b test.asm", 1, "", <<END);
Error at file 'test.asm' line 4: integer '65536' out of range
END


unlink_testfiles();
spew("test.asm", "
	defvars 							;; error: syntax error
");
run("./z88dk-z80asm -b test.asm", 1, "", <<END);
Error at file 'test.asm' line 2: syntax error
END


unlink_testfiles();
spew("test.asm", "
	defvars 0							;; error: missing {} block
");
run("./z88dk-z80asm -b test.asm", 1, "", <<END);
Error at file 'test.asm' line 3: missing {} block
END


unlink_testfiles();
spew("test.asm", "
	defvars 0 {							;; error: {} block not closed
");
run("./z88dk-z80asm -b test.asm", 1, "", <<END);
Error at file 'test.asm' line 3: {} block not closed
END


# BUG_0051: DEFC and DEFVARS constants do not appear in map file
unlink_testfiles();
z80asm(<<END, "-r4 -b -m -g -Dminus_d_var");
			public minus_d_var, defc_var, defvars_var, public_label
			defc defc_var = 2
			defvars 3 { 
			defvars_var ds.b 1
			}
		public_label: 
			defb minus_d_var	;; 01
			defb defc_var		;; 02
			defb defvars_var	;; 03
			defb public_label	;; 04
			defb local_label 	;; 09
		local_label:
END
check_bin_file("test.bin", "\x01\x02\x03\x04\x09");
check_text_file("test.def", <<'END');
	DEFC minus_d_var                     = $0001
	DEFC defc_var                        = $0002
	DEFC defvars_var                     = $0003
	DEFC public_label                    = $0004
END
check_text_file("test.map", <<'END');
	local_label                     = $0009 ; addr, local, , test, , test.asm:12
	minus_d_var                     = $0001 ; const, public, , test, ,
	defc_var                        = $0002 ; const, public, , test, , test.asm:2
	defvars_var                     = $0003 ; const, public, , test, , test.asm:4
	public_label                    = $0004 ; addr, public, , test, , test.asm:6
	__head                          = $0004 ; const, public, def, , ,
	__tail                          = $0009 ; const, public, def, , ,
	__size                          = $0005 ; const, public, def, , ,
END

# Empty sections do not appear in the map file, except "" section
z80asm(<<END, "-r4 -b -m -g -Dminus_d_var");
				; empty			;; 
END
check_bin_file("test.bin", "");
check_text_file("test.map", <<'END');
	__head                          = $0004 ; const, public, def, , ,
	__tail                          = $0004 ; const, public, def, , ,
	__size                          = $0000 ; const, public, def, , ,
END

z80asm(<<END, "-b -m");
				section empty
				section code
				nop				;; 00
END
check_bin_file("test.bin", "\x00");
check_text_file("test.map", <<'END');
	__head                          = $0000 ; const, public, def, , ,
	__tail                          = $0001 ; const, public, def, , ,
	__size                          = $0001 ; const, public, def, , ,
	__empty_head                    = $0000 ; const, public, def, , ,
	__empty_tail                    = $0000 ; const, public, def, , ,
	__empty_size                    = $0000 ; const, public, def, , ,
	__code_head                     = $0000 ; const, public, def, , ,
	__code_tail                     = $0001 ; const, public, def, , ,
	__code_size                     = $0001 ; const, public, def, , ,
END


# defvars with link-time constants
unlink_testfiles();
z80asm(<<'END', "", 1, "", <<'ERR');
	extern START
	defvars START {
		df0 ds.b 1
		df1 ds.b 1
	}
END
Error at file 'test.asm' line 2: expected constant expression
ERR


unlink_testfiles();
z80asm(<<'END', "", 1, "", <<'ERR');
	extern START
	defvars START 
	{
		df0 ds.b 1
		df1 ds.b 1
	}
END
Error at file 'test.asm' line 2: expected constant expression
ERR


unlink_testfiles();
z80asm(<<'END', "", 1, "", <<'ERR');
	defvars undefined					;; error: symbol 'undefined' not defined
	{
		df2	ds.q 1
	}
END
Error at file 'test.asm' line 1: symbol 'undefined' not defined
Error at file 'test.asm' line 1: expected constant expression
ERR


unlink_testfiles();
z80asm(<<'END', "", 1, "", <<'ERR');
	extern LEN
	defvars 0 {
		df0 ds.b LEN
		df1 ds.b undefined
	}
END
Error at file 'test.asm' line 3: expected constant expression
Error at file 'test.asm' line 4: symbol 'undefined' not defined
Error at file 'test.asm' line 4: expected constant expression
ERR


unlink_testfiles();
done_testing();

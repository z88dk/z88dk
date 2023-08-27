#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# signle source
z80asm_ok("", "", "", <<END, 
	defc defvars_base = 0x80			;;
	defvars defvars_base				;;
										;;
	{									;;
		df1 ds.b 4						;; ; df1 = 0x80
		df2 ds.w 2						;; ; df2 = 0x80 + 4 = 0x84
		df3 ds.p 2						;; ; df3 = 0x84 + 2*2 = 0x88
		df4 ds.q 2						;; ; df4 = 0x88 + 2*3 = 0x8E
		df5 							;; ; df5 = 0x8E + 2*4 = 0x96
		rl								;; ; opcode can be used as constant
										;;
	}									;;
	defb df1, df2, df3, df4, df5, rl	;; defb 80h, 84h, 88h, 8Eh, 96h, 96h
	
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
	bytes(	0x80, 0x84, 0x88, 0x8E, 0x96, 0x96,
			0, 1, 2,
			0x96, 0x97, 0x98, 0x98,
			0, 1, 2, 
			0x98, 0x99, 0x9A, 0x9A,
			0, 1,
			0, 2,
));

# multiple sources
spew("$test.asm", <<END);
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
END

spew("$test.1.asm", <<END);
	defvars -1 ; continue after df5		
	{									
		df9  ds.b 1						; df9 = 0x96
		df10 ds.b 1						; df10 = 0x97
		df11							; df11 = 0x98
		df12							; df12 = 0x98
	}									
	defb df9, df10, df11, df12			;; 96 97 98 98
END

spew("$test.2.asm", <<END);
	defvars -1 ; continue after df12	
	{									
		df16 ds.b 1						; df16 = 0x98
		df17 ds.b 1						; df17 = 0x99
		df18							; df18 = 0x9A
	}									
	defb df16, df17, df18				;; 98 99 9A
END

run_ok("z88dk-z80asm -b $test.asm $test.1.asm $test.2.asm");
check_bin_file("$test.bin", 
	bytes(0x80, 0x84, 0x88, 0x8E, 0x96, 0x96, 0x97, 0x98, 0x98, 0x98, 0x99, 0x9A));


z80asm_ok("", "", "", <<END, bytes(0));
	defvars -1 ; continue from 0
	{
		df1	ds.b 1
	}
	defb df1							;; 00
END


z80asm_nok("", "", <<END, <<END);
	defvars 0
	{
		df1	ds.q 10
		df2	ds.q 16383
	}
END
$test.asm:4: error: integer range: \$10024
  ^---- df2 ds.q 16383
END


z80asm_nok("", "", <<END, <<END);
	defvars 0
	{
		df2	ds.q 16384
	}
END
$test.asm:3: error: integer range: \$10000
  ^---- df2 ds.q 16384
END


z80asm_nok("", "", <<END, <<END);
	defvars
END
$test.asm:1: error: syntax error
  ^---- defvars
END


z80asm_nok("", "", <<END, <<END);
	defvars 0
END
$test.asm:2: error: missing {} block
END


z80asm_nok("", "", <<END, <<END);
	defvars 0 {
END
$test.asm:2: error: {} block not closed
END


# defvars with link-time constants
z80asm_nok("", "", <<END, <<END);
	extern START
	defvars START {
		df0 ds.b 1
		df1 ds.b 1
	}
END
$test.asm:2: error: constant expression expected
  ^---- defvars START {
END


z80asm_nok("", "", <<END, <<END);
	extern START
	defvars START 
	{
		df0 ds.b 1
		df1 ds.b 1
	}
END
$test.asm:2: error: constant expression expected
  ^---- defvars START
END


z80asm_nok("", "", <<END, <<END);
	defvars undefined
	{
		df2	ds.q 1
	}
END
$test.asm:1: error: undefined symbol: undefined
  ^---- defvars undefined
$test.asm:1: error: constant expression expected
  ^---- defvars undefined
END


z80asm_nok("", "", <<END, <<END);
	extern LEN
	defvars 0 {
		df0 ds.b LEN
		df1 ds.b undefined
	}
END
$test.asm:3: error: constant expression expected
  ^---- df0 ds.b LEN
$test.asm:4: error: undefined symbol: undefined
  ^---- df1 ds.b undefined
$test.asm:4: error: constant expression expected
  ^---- df1 ds.b undefined
END

unlink_testfiles;
done_testing;

;       NEC PC-8801 stub
;
;       Stefano Bodrato - 2018
;
;	$Id: pc88_crt0.asm $
;

        MODULE  pc88_crt0


	defc    crt0 = 1
        INCLUDE "zcc_opt.def"

	EXTERN    _main

        PUBLIC    cleanup
        PUBLIC    l_dcal

	PUBLIC	__CLIB_PC8800_HAS_BASIC
	PUBLIC	pc88bios
		
	defc	__CPU_CLOCK = 4000000

IF (!DEFINED_startup || (startup=1))
	defc __CLIB_PC8800_HAS_BASIC = 1
	INCLUDE	"target/pc88/classic/monitor.asm"
ELSE
	defc __CLIB_PC8800_HAS_BASIC = 0
	INCLUDE	"target/pc88/classic/allram.asm"
ENDIF

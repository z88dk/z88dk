;       NEC PC-8801 stub
;
;       Stefano Bodrato - 2018
;
;	$Id: pc88_crt0.asm $
;

    MODULE  pc88_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main

    PUBLIC  l_dcal
    PUBLIC  cleanup

    PUBLIC	__CLIB_PC8800_HAS_BASIC
    PUBLIC	pc88bios

    PUBLIC  __CLIB_PC8800_V2_ENABLED

IF DEFINED_CLIB_PC8800_V2_ENABLED
    defc    __CLIB_PC8800_V2_ENABLED = CLIB_PC8800_V2_ENABLED
ELSE
    defc    __CLIB_PC8800_V2_ENABLED = 1
ENDIF

    defc    __CPU_CLOCK = 4000000

IF (!DEFINED_startup || (startup=1))
    defc    __CLIB_PC8800_HAS_BASIC = 1
    INCLUDE "target/pc88/classic/monitor.asm"
ELSE
    defc    __CLIB_PC8800_HAS_BASIC = 0
    INCLUDE "target/pc88/classic/allram.asm"
ENDIF

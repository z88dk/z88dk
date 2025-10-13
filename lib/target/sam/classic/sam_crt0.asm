;       Startup fo SAM Coupe
;
;       Stefano 26/3/2001
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: sam_crt0.asm,v 1.20 2016-06-21 20:49:06 dom Exp $
;


        MODULE  sam_crt0

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"


        EXTERN    _main


    PUBLIC    __Exit
    PUBLIC    l_dcal
    PUBLIC	  SCREEN_BASE

    defc CLIB_ZX_CONIO32 = 0
    defc CONSOLE_COLUMNS = 32
    PUBLIC __CLIB_ZX_CONIO32
    defc __CLIB_ZX_CONIO32 = CLIB_ZX_CONIO32
    defc CONSOLE_ROWS = 24

IFNDEF CLIB_FGETC_CONS_DELAY
    defc    CLIB_FGETC_CONS_DELAY = 150
ENDIF
IFNDEF CLIB_KBHIT_DELAY
    defc    CLIB_KBHIT_DELAY = 100
ENDIF
    defc    CRT_KEY_DEL = 12

    PUBLIC CLIB_SAM_IS_BASIC

    defc    __CPU_CLOCK = 6000000

IFNDEF CLIB_DEFAULT_SCREEN_MODE
    defc       CLIB_DEFAULT_SCREEN_MODE = 4
ENDIF

    INCLUDE	"target/sam/def/sam.def"

    PUBLIC IO_SAA1099_DATA_PORT
    PUBLIC IO_SAA1099_ADDRESS_PORT

IF (!DEFINED_startup || (startup=1))
    INCLUDE "target/sam/classic/basic.asm"
ELIF (startup=2)
    INCLUDE "target/sam/classic/allram.asm"
ELIF (startup=3)
    INCLUDE "target/sam/classic/highram.asm"
ENDIF


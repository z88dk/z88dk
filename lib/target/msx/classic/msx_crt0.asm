
    MODULE  msx_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main

    PUBLIC  cleanup
    PUBLIC  l_dcal
    PUBLIC  msxbios

    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF
    defc    __CPU_CLOCK = 3580000

IF (!DEFINED_startup || (startup=1))
    INCLUDE	"target/msx/classic/ram.asm"
ENDIF

IF startup = 2
    INCLUDE	"target/msx/classic/msxdos.asm"
ENDIF

IF startup = 3
    INCLUDE	"target/msx/classic/rom.asm"
ENDIF


    SECTION code_clib

; Safe BIOS call
msxbios:
    ld      iy,($FCC0)  ; slot address of BIOS ROM
    call    001Ch       ; CALSLT
    ei                  ; make sure interrupts are enabled
    ret




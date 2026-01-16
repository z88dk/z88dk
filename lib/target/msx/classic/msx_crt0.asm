
    MODULE  msx_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main

    PUBLIC  __Exit
    PUBLIC  l_dcal
    PUBLIC  msxbios

    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF
    defc    __CPU_CLOCK = 3580000

    ; Don't change the screenmode by default
IFNDEF CLIB_DEFAULT_SCREEN_MODE
    defc CLIB_DEFAULT_SCREEN_MODE = -1
ENDIF


IF (!DEFINED_startup || (startup=1))
    INCLUDE	"target/msx/classic/ram.asm"
ENDIF

IF startup = 2
    INCLUDE	"target/msx/classic/msxdos.asm"
ENDIF

IF startup = 3
    INCLUDE	"target/msx/classic/rom.asm"
ENDIF


IFDEF __bdos
    PUBLIC  __bdos
ENDIF


    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_disable.inc"

    SECTION code_clib

; Safe BIOS call
msxbios:
    ld      iy,($FCC0)  ; slot address of BIOS ROM
    call    001Ch       ; CALSLT
    ei                  ; make sure interrupts are enabled
    ret

    SECTION UNASSIGNED
    org     0





    SECTION code_driver

    PUBLIC  generic_console_printc


    EXTERN  printc_MODE0
    EXTERN  printc_MODE1
    EXTERN  printc_MODE2
    EXTERN  __mc6847_mode


    INCLUDE "video/mc6847/mc6847.inc"



; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    ld      a, (__mc6847_mode)
    ld      h,a
    and     0xfd
IF MC6847_HAS_HIRES
    cp      MODE_HIRES & 0xfd
    jp      z, printc_MODE1
ENDIF
    cp      MODE_MULTICOLOUR & 0xfd
    jp      z, printc_MODE2
IFNDEF FORspc1000
    and     a
    ret     nz
ENDIF
    ld      a, h
    jp      printc_MODE0

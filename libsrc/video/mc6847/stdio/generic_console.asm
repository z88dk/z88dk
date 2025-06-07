
    SECTION code_clib

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
    ex      af, af
    ld      a, (__mc6847_mode)
    and     @11111101
IF MC6847_HAS_HIRES
    cp      MODE_HIRES
    jp      z, printc_MODE1
ENDIF
    cp      MODE_MULTICOLOUR
    jp      z, printc_MODE2
IF !FORspec1000
    and     a
    ret     nz
    ex      af,af
ENDIF
    jp      printc_MODE0


    SECTION code_driver

    PUBLIC  generic_console_printc


    EXTERN  printc_MODE0
    EXTERN  printc_MODE1
    EXTERN  printc_MODE2
    EXTERN  __mc6847_mode


    INCLUDE "classic/video/mc6847/mc6847.inc"



; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    ld      a, (__mc6847_mode)
IF MC6847_HAS_HIRES
    cp      1
    jp      z, printc_MODE1
ENDIF
IF MC6847_HAS_CG
    cp      2
    jp      z, printc_MODE2
ENDIF
IFNDEF FORspc1000
    and     a
    ret     nz
ENDIF
    jp      printc_MODE0


    MODULE	sc3000_crt

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN    _main

    PUBLIC    cleanup
    PUBLIC    l_dcal



    PUBLIC  msxbios

    ; Always use the generic console unless overridden
    defc    TAR__fputc_cons_generic = 1
    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF
    defc    CRT_KEY_DEL = 12

IF startup = 2
	INCLUDE	"target/sc3000/classic/rom.asm"
ELSE
	INCLUDE "target/sc3000/classic/ram.asm"
ENDIF


l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.asm"

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms9918/mode_disable.asm"

; ---------------
; MSX specific stuff
; ---------------
; Safe BIOS call
msxbios:
    push    ix
    ret


    INCLUDE "crt/classic/crt_section.asm"

    SECTION data_crt
    PUBLIC  _sc_cursor_pos

_sc_cursor_pos: defw    0x9489


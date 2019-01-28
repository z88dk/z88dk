
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
        defc    CONSOLE_ROWS = 24
        defc    CRT_KEY_DEL = 12

IF startup = 2
	INCLUDE	"target/sc3000/classic/rom.asm"
ELSE
	INCLUDE "target/sc3000/classic/ram.asm"
ENDIF


l_dcal:
        jp      (hl)


        INCLUDE "crt/classic/crt_runtime_selection.asm"

; ---------------
; MSX specific stuff
; ---------------
; Safe BIOS call
msxbios:
        push    ix
        ret


        INCLUDE         "crt/classic/crt_section.asm"

        SECTION         data_crt
        PUBLIC          _sc_cursor_pos

_sc_cursor_pos: defw    0x9489

        SECTION         bss_crt

        PUBLIC  RG0SAV          ;keeping track of VDP register values
        PUBLIC  RG1SAV
        PUBLIC  RG2SAV
        PUBLIC  RG5SAV
        PUBLIC  RG6SAV
        PUBLIC  RG7SAV

RG0SAV:			defb    0       ;keeping track of VDP register values
RG1SAV:			defb    0
RG2SAV:			defb    0
RG3SAV:			defb    0
RG4SAV:			defb    0
RG5SAV:			defb    0
RG6SAV:			defb    0
RG7SAV:			defb    0


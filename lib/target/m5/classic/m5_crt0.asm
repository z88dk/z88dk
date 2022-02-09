
    MODULE	m5_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main

    PUBLIC  cleanup
    PUBLIC  l_dcal



    PUBLIC  msxbios

; Always use the generic console unless overridden
    defc    TAR__fputc_cons_generic = 1
    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF
    defc    __CPU_CLOCK = 3579999
    defc    CRT_KEY_DEL = 12

IF startup = 2
    INCLUDE	"target/m5/classic/rom.asm"
ELSE
    INCLUDE "target/m5/classic/ram.asm"
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



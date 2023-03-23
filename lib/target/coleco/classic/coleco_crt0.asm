;       Coleco (Console + Adam + Bit90)

    MODULE  coleco_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main
    EXTERN  msxbios

    PUBLIC  l_dcal
    PUBLIC  cleanup
    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF

    EXTERN    __vdp_enable_status
    EXTERN    VDP_STATUS
    EXTERN      __tms9918_status_register

    defc    __CPU_CLOCK = 3579545

IF (!DEFINED_startup || (startup=1))
    INCLUDE "target/coleco/classic/rom.asm"
ELSE
    INCLUDE "target/coleco/classic/allram.asm"
ENDIF

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms9918/mode_disable.asm"

;       Coleco (Console + Adam + Bit90)

    MODULE  coleco_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main
    EXTERN  msxbios

    PUBLIC  l_dcal
    PUBLIC  __Exit
    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF

    EXTERN    __vdp_enable_status
    EXTERN    VDP_STATUS
    EXTERN      __tms9918_status_register

    defc    __CPU_CLOCK = 3579545


    PUBLIC  __IO_SN76489_PORT
    defc    __IO_SN76489_PORT = $ff


IF (!DEFINED_startup || (startup=1))
    INCLUDE "target/coleco/classic/rom.asm"
ELSE
    INCLUDE "target/coleco/classic/allram.asm"
ENDIF

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_disable.inc"

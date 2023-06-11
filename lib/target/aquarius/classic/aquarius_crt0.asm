;       CRT0 for the Mattel Aquarius
;
;       Stefano Bodrato Dec. 2000
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: aquarius_crt0.asm,v 1.21 2016-07-15 21:03:25 dom Exp $
;



    MODULE  aquarius_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

    defc    TAR__no_ansifont = 1
    defc    CONSOLE_ROWS = 24
    defc    CONSOLE_COLUMNS = 40
    defc    __CPU_CLOCK = 4000000



IF startup = 1 
    INCLUDE "target/aquarius/def/maths_mbf.def"
    INCLUDE	"target/aquarius/classic/ram.asm"
ELSE
    INCLUDE	"target/aquarius/classic/rom.asm"
ENDIF


l_dcal: 
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.asm"

    INCLUDE	"crt/classic/crt_section.asm"

    SECTION code_crt_init
    ld      hl,$3028
    ld      (base_graphics),hl



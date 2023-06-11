;
;       Startup for Microbee in BASIC mode
;       RUNM "program"
;
;       Stefano Bodrato - 2016
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: bee_crt0.asm,v 1.1 2016-11-15 08:11:10 stefano Exp $
;



    MODULE  bee_crt0



    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

    defc    CONSOLE_COLUMNS = 80
    defc    CONSOLE_ROWS = 25

IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $900  ; clean binary block
ENDIF


    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc    __CPU_CLOCK = 2000000
    INCLUDE	"crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE




start:
    ld      (__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld  (exitsp),sp


IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    call    _main
cleanup:

    LD      HL,vdutab
    LD      C,0
    LD	    B,16
.vdloop
    LD      A,C
    OUT     ($0C),A
    LD      A,(HL)
    OUT     ($0D),A
    INC     HL
    INC     C
    DJNZ    vdloop

    call    crt0_exit
__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:
    jp      (hl)

.vdutab ; 64*16
    defb    107,64,81,55,18,9,16,17,$48,$0F,$2F,$0F,0,0,0,0  



    INCLUDE "crt/classic/crt_runtime_selection.asm"

    INCLUDE "crt/classic/crt_section.asm"


    SECTION	code_crt_init
    nop
    ;ld	hl,$
    ;ld	(base_graphics),hl

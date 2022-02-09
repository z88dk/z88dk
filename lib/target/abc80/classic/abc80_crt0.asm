;       CRT0 for the ABC80 Family
;
;       Stefano Bodrato May 2000
;
;       $Id: abc80_crt0.asm,v 1.20 2016-07-15 21:03:25 dom Exp $
;

    MODULE  abc80_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN    _main


    PUBLIC    cleanup
    PUBLIC    l_dcal

    defc	CONSOLE_ROWS = 24
    defc	CONSOLE_COLUMNS = 40

IF !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = 50000
ENDIF
    defc	TAR__no_ansifont = 1
    defc	TAR__clib_exit_stack_size = 32
    defc	TAR__register_sp = -1
    defc	__CPU_CLOCK = 3000000
    INCLUDE	"crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


start:
    ld      (__restore_sp_onexit+1),sp
    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss
    ld      (exitsp),sp


IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    call    _main
        
cleanup:
    push	hl
    call    crt0_exit

    pop     bc
__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE	"crt/classic/crt_section.asm"


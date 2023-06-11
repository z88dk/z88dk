;       CRT0 (RAM) stub for the SEGA SC-3000
;
;       Stefano Bodrato - Jun 2010
;

    IF      !CRT_ORG_CODE
        defc    CRT_ORG_CODE  = $9817
    ENDIF
    defc    TAR__register_sp = -1

    defc    TAR__clib_exit_stack_size = 32
    defc    __CPU_CLOCK = 3580000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

;  ******************** ********************
;           B A S I C    M O D E
;  ******************** ********************

start:
    ld      hl,0
    add     hl,sp
    ld      (__restore_sp_onexit+1),sp
    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"

;  ******************** ********************
;    BACK TO COMMON CODE FOR ROM AND BASIC
;  ******************** ********************

    call    crt0_init_bss
    ld      (exitsp),sp

    IF DEFINED_USING_amalloc
        INCLUDE "crt/classic/crt_init_amalloc.asm"
    ENDIF

; Entry to the user code
    call    _main

cleanup:
    push    hl
    call    crt0_exit


__restore_sp_onexit:
    ld      sp,0
    ret

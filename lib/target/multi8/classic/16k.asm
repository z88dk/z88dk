;       CRT0 for the Multi8 (16k mode)
;

    IF      !DEFINED_CRT_ORG_CODE
        defc    CRT_ORG_CODE  = 0xC000
    ENDIF


    defc    VRAM_IN = 0x17
    defc    VRAM_OUT = 0x0f
    defc    __PORT29_COPY = 0xf0bb

    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    INCLUDE "crt/classic/crt_rules.inc"
    org     CRT_ORG_CODE

start:

    ld      (__restore_sp_onexit+1),sp    ;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

    ld      a,(SYSVAR_PORT29_COPY)
    ld      (__port29_copy),a

IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


    call    _main    ;Call user program

cleanup:
    push    hl
    call    crt0_exit


    pop    bc
__restore_sp_onexit:   ld    sp,0        ;Restore stack to entry value
    ret

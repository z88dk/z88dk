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
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    ld      a,(SYSVAR_PORT29_COPY)
    ld      (__port29_copy),a

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main    ;Call user program

__Exit:
    push    hl
    call    crt0_exit
    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0        ;Restore stack to entry value
    ret

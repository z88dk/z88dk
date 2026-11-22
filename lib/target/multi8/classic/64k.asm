;    CRT0 stub for 64k Mode Multi8
;
;


    defc    CRT_ORG_CODE  = 0x0000
    defc    TAR__register_sp = 0xffff
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__crt_enable_eidi = $02
    defc    TAR__crt_on_exit = $10001       ;loop forever
    defc    VRAM_IN = 0x37;
    defc    VRAM_OUT = 0x2f

    ; We want to intercept rst38 to our interrupt routine
    defc    TAR__crt_enable_rst = $8080
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler
    IFNDEF CRT_ENABLE_NMI
        defc    TAR__crt_enable_nmi = 1
        EXTERN  asm_nmi_handler
        defc    _z80_nmi = asm_nmi_handler
    ENDIF

    INCLUDE    "crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE
    jp      program
    INCLUDE    "crt/classic/crt_z80_rsts.inc"

program:
    ; Make room for the atexit() stack
    INCLUDE    "crt/classic/crt_init_sp.inc"

    call    crt0_init
    INCLUDE    "crt/classic/crt_init_atexit.inc"

    ld      a,(SYSVAR_PORT29_COPY)
    ld      (__port29_copy),a
    INCLUDE "crt/classic/crt_init_heap.inc"
    im      1
    INCLUDE "crt/classic/crt_init_eidi.inc"

; Entry to the user code
    call    _main

__Exit:
    push    hl
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"




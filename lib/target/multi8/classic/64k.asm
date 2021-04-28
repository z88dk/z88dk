;    CRT0 stub for 64k Mode Multi8
;
;


    defc    CRT_ORG_CODE  = 0x0000
    defc    TAR__register_sp = 0xffff
    defc    TAR__clib_exit_stack_size = 0
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

    INCLUDE    "crt/classic/crt_z80_rsts.asm"

program:
    ; Make room for the atexit() stack
    INCLUDE    "crt/classic/crt_init_sp.asm"
    INCLUDE    "crt/classic/crt_init_atexit.asm"

    call    crt0_init_bss
    ld      (exitsp),sp

    ld      a,(SYSVAR_PORT29_COPY)
    ld      (__port29_copy),a


IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


    im      1
    ei

; Entry to the user code
    call    _main

cleanup:
    push    hl
    call    crt0_exit


endloop:
    jr      endloop


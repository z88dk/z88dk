;
;	ROM Startup for SVI
;


IF !DEFINED_CRT_ORG_BSS
    defc    CRT_ORG_BSS = 0x8000
ENDIF
    defc    CRT_ORG_CODE = 0x0000

    EXTERN  im1_vectors
    EXTERN  asm_interrupt_handler

    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xffff
    defc    TAR__crt_enable_eidi = $02
    defc    TAR__crt_on_exit = $10001

    ; VDP signals delivered to im1 usually
    defc    TAR__crt_enable_rst = $8080
    defc    _z80_rst_38h = tms9918_interrupt

    ; NMI can get VDP, but only in certain hardware configs - later
    defc    TAR__crt_enable_nmi = -1	; Just gets us a retn


    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif
    di                  ;Signature is di, ld sp
    ld      sp,0xffff
    jp      program

    INCLUDE "crt/classic/crt_z80_rsts.inc"

    ; IM1 interrupt routine
    INCLUDE "crt/classic/tms99x8/tms99x8_interrupt.inc"
    ei
    reti

int_VBL:
    ld      hl,im1_vectors
    call    asm_interrupt_handler
    pop     hl
    pop     af
    ei
    reti

program:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_init.inc"
    im      1
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"


l_dcal:
    jp      (hl)            ;Used for function pointer calls

    defc    __crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF


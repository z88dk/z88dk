;       CRT0 (rom) stub for the SEGA SC-3000/SG-1000
;
;       Stefano Bodrato - Jun 2010
;
;	$Id: sc3000_crt0.asm,v 1.18 2016-07-13 22:12:25 dom Exp $
;

IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = 0x0000
ENDIF
    ; This sp value is good for both SC-3000 and SG-1000, to run on the SC-3000
    ; only use:  -pragma-define:REGISTER_SP=0xc7f0
    defc    TAR__register_sp = $c400
IF !DEFINED_CRT_ORG_BSS
    defc    CRT_ORG_BSS = $c000
    defc DEFINED_CRT_ORG_BSS = 1
ENDIF   


    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__fgetc_cons_inkey = 1
    defc	__CPU_CLOCK = 3580000
    defc    TAR__crt_enable_eidi = $02

    ; VDP signals delivered to im1
    defc    TAR__crt_enable_rst = $8080
    defc    _z80_rst_38h = tms9918_interrupt

    ; NMI is delivered by BREAK on the keyboard
    IFNDEF CRT_ENABLE_NMI
        defc TAR__crt_enable_nmi = 1
        EXTERN asm_nmi_handler
        defc _z80_nmi = asm_nmi_handler
    ENDIF

    IFNDEF CLIB_DEFAULT_SCREEN_MODE
        defc    CLIB_DEFAULT_SCREEN_MODE = 1
    ENDIF

    INCLUDE	"crt/classic/crt_rules.inc"


    EXTERN  vdp_set_mode
    EXTERN  im1_vectors
    EXTERN  asm_interrupt_handler

    org     CRT_ORG_CODE

if (ASMPC = $0000)
    di
    jp      program

    INCLUDE	"crt/classic/crt_z80_rsts.inc"

    ; Interrupt routine, defines tms9918_interrupt
    INCLUDE	"crt/classic/tms99x8/tms99x8_interrupt.inc"
    ei
    reti

int_VBL:
    ld      hl,im1_vectors
    call    asm_interrupt_handler
    pop     hl
    pop     af
    ei
    reti
ENDIF



program:
    INCLUDE	"crt/classic/crt_init_sp.inc"

    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"

    INCLUDE "crt/classic/tms99x8/tms99x8_mode_init.inc"

    im      1
    INCLUDE "crt/classic/crt_init_eidi.inc"

; Entry to the user code
    call    _main

__Exit:
    push    hl
    call    crt0_exit
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_exit.inc"
    pop     hl
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"


    defc    __crt_org_bss = CRT_ORG_BSS
    ; If we were given a model then use it
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF

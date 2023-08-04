;      Sord M5 ROM crt0 
;
;      Sord memory starts from 0x7000 and is 4k long
;      im2 interrupt vectors from 0x7000



    defc    CRT_ORG_CODE = 0x2000
    defc    CRT_ORG_BSS = 0x7100

    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0x7fff
    ; Default, halt loop
    defc    TAR__crt_on_exit = 0x10001
    INCLUDE "crt/classic/crt_rules.inc"


    EXTERN  vdp_set_mode
    EXTERN  im1_vectors
    EXTERN  asm_interrupt_handler

    org     CRT_ORG_CODE

    defb	$00     ;$2000 Needs to be non zero
    defw	prehook ;$2001 pre hook
    defw	start   ;$2003 main routine


prehook:
    ret


start:
    di
    ; Overwrite the system vbl interrupt handler with ours
    ld      hl,tms9918_interrupt
    ld      ($7006),hl


    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"

    call    crt0_init_bss
    ld      (exitsp),sp
    ld      hl,2
    call    vdp_set_mode
    ei


IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


    call    _main           ; Call user program
cleanup:
    call    crt0_exit
cleanup_exit:
    ; How does the program end?
    INCLUDE "crt/classic/crt_terminate.inc"



    INCLUDE	"crt/classic/tms9918/interrupt.asm"
    ei
    reti

int_VBL:
    ld      hl,im1_vectors
    call    asm_interrupt_handler
    pop     hl
    pop     af
    ei
    reti


    defc    __crt_org_bss = CRT_ORG_BSS
    ; If we were given a model then use it
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF

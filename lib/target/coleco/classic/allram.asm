;   CRT0 stub for 64k adam

    INCLUDE     "target/coleco/def/eos.def"


    EXTERN  vdp_set_mode

    defc    TAR__register_sp = 0xd390
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__fputc_cons_generic = 1

    ; No interrupts registered
    defc    TAR__crt_enable_rst = $0000
    IFNDEF CRT_ENABLE_NMI
        defc        TAR__crt_enable_nmi = 1
        defc        _z80_nmi = nmi_handler
    ENDIF

    defc    CRT_ORG_CODE = 0

    EXTERN  nmi_vectors
    EXTERN  asm_interrupt_handler

    INCLUDE "crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE

    jp      program

    INCLUDE "crt/classic/crt_z80_rsts.asm"

program:
    ; Make room for the atexit() stack
    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"

    call    crt0_init_bss
    ld      (exitsp),sp

    ld      hl,2
    call    vdp_set_mode

IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

        ; Entry to the user code
    call    _main

cleanup:
    call    crt0_exit
endloop:
    jr      endloop

l_dcal:
    jp      (hl)

IF (__crt_enable_nmi <= 1)
nmi_handler:
    push    af
    push    hl
    ld      a,(__vdp_enable_status)
    rlca
    jr      c,no_vbl
    in      a,(VDP_STATUS)
    ld      (__tms9918_status_register),a
no_vbl:
    ld      hl,nmi_vectors
    call    asm_interrupt_handler
    pop     hl
    pop     af
    retn
ENDIF


; We're not using that much from EOS, so put these here
; until we've got more functionality that should go into
; a library
PUBLIC fgetc_cons
PUBLIC _fgetc_cons
fgetc_cons:
_fgetc_cons:
    call    ReadKeyboard
    jr      nz,fgetc_cons
    ld      l,a
    ld      h,0
    cp      13
    ret     nz
    ld      l,10
    ret



; msxbios is a noop
msxbios:
    ret

    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"

    ; Include the IPL bootstrap code
    INCLUDE "target/coleco/classic/adam_bootstrap.asm"


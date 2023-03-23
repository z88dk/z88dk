;
;	Startup for V-Tech VZ-350/500/700?
;


    defc    CRT_ORG_BSS = 0xc000
    defc    CRT_ORG_CODE = 0x0000

    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xbfff

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif
    defb	0xaa,0x55,0xe7,0x18		;Signature
    jp      program

    INCLUDE	"crt/classic/crt_z80_rsts.asm"


program:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp
    im      1
    ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    call    _main
cleanup:
    di
    halt
    jp      cleanup


l_dcal: jp      (hl)            ;Used for function pointer calls

    defc    __crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF


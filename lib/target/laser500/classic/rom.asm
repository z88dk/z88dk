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

    INCLUDE	"crt/classic/crt_z80_rsts.inc"


program:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    im      1
    ei

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"



l_dcal: jp      (hl)            ;Used for function pointer calls

    defc    __crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF


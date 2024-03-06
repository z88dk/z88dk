;       Startup Code for Embedded Targets
;
;	Daniel Wallner March 2002
;


    DEFC    ROM_Start  = $0000
    DEFC    RAM_Start  = $8000
    DEFC    Stack_Top  = $ffff

    MODULE  embedded_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main           ;main() is always external to crt0 code
    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)
    EXTERN	  asm_im1_handler
    EXTERN	  asm_nmi_handler

IF DEFINED_CRT_ORG_BSS
        defc    __crt_org_bss = CRT_ORG_BSS
ELSE
	defc	__crt_org_bss = RAM_Start
ENDIF

IF      !CRT_ORG_CODE
    defc	CRT_ORG_CODE = ROM_Start
ENDIF

IF CRT_ORG_CODE = 0x0000
    ; We want to intercept rst38 to our interrupt routine
    defc    TAR__crt_enable_rst = $8080
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler
    IFNDEF CRT_ENABLE_NMI
        defc	TAR__crt_enable_nmi = 1
    EXTERN	asm_nmi_handler
        defc	_z80_nmi = asm_nmi_handler
    ENDIF
ENDIF
	
    defc	TAR__register_sp = Stack_Top
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__crt_on_exit = 0x10001      ;loop forever
    defc	__CPU_CLOCK = 4000000
    INCLUDE	"crt/classic/crt_rules.inc"


    org    	CRT_ORG_CODE


IF CRT_ORG_CODE = 0x0000
    jp      start
    INCLUDE	"crt/classic/crt_z80_rsts.inc"
ENDIF

start:
    INCLUDE	"crt/classic/crt_init_sp.inc"
    ; Make room for the atexit() stack
    INCLUDE	"crt/classic/crt_init_atexit.inc"
    call	crt0_init_bss
    ld      (exitsp),sp

    INCLUDE "crt/classic/crt_init_eidi.inc"
    ; Entry to the user code
    call    _main
    ; Exit code is in hl
cleanup:
    call    crt0_exit
    INCLUDE "crt/classic/crt_terminate.inc"
l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.inc"

    ; If we were given a model then use it
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
	INCLUDE	"crt/classic/crt_section.inc"

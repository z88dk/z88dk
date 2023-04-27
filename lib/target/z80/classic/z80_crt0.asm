;
; A configurable CRT for bare-metal
;
;

    MODULE z80_crt0 

;-------
; Include zcc_opt.def to find out information about us
;-------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

    EXTERN    _main           ;main() is always external to crt0 code
    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)
    EXTERN	  asm_im1_handler
    EXTERN	  asm_nmi_handler

IF DEFINED_CRT_ORG_BSS
    defc    __crt_org_bss = CRT_ORG_BSS
ENDIF

IFNDEF      CRT_ORG_CODE
    defc    CRT_ORG_CODE = 0x0000
ENDIF

IF CRT_ORG_CODE = 0x0000
    ; By default we don't have any rst handlers
    defc    TAR__crt_enable_rst = $0000
ENDIF

    ; Default, don't change the stack pointer
    defc    TAR__register_sp = -1
    defc    TAR__clib_exit_stack_size = 32
    ; Default, halt loop
    defc    TAR__crt_on_exit = 0x10001

    defc    __CPU_CLOCK = 4000000
    INCLUDE "crt/classic/crt_rules.inc"


    org    	CRT_ORG_CODE


IF CRT_ORG_CODE = 0x0000
    jp      start
    INCLUDE "crt/classic/crt_z80_rsts.asm"
ENDIF

start:
    INCLUDE "crt/classic/crt_start_eidi.inc"
    INCLUDE "crt/classic/crt_init_sp.asm"
    ; Make room for the atexit() stack
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
IF __CPU_INTEL__
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
ELSE
    ld      (exitsp),sp
ENDIF

    ; Entry to the user code
    call    _main
    ; Exit code is in hl
cleanup:
    call    crt0_exit

    ; How does the program end?
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal:
    jp      (hl)

    INCLUDE "crt/classic/crt_runtime_selection.asm"

    ; If we were given a model then use it
IF DEFINED_CRT_MODEL
    defc __crt_model = CRT_MODEL
ELSE
    defc __crt_model = 1
ENDIF
    INCLUDE	"crt/classic/crt_section.asm"

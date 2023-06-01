;
; A configurable CRT for agon/MOS
;
;

    MODULE agon_crt0 

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

    defc      CONSOLE_COLUMNS = 80
    defc      CONSOLE_ROWS = 25

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
        defs    $0008-ASMPC
	defb	$49		;LIS prefix
	rst	$08

        defs    $0010-ASMPC
	defb	$49		;LIS prefix
	rst	$10

        defs    $0018-ASMPC
	defb	$49		;LIS prefix
	rst	$18

        defs    $0038-ASMPC
	ei
	reti

    defs    64 - ASMPC
if (ASMPC<>64)
        defs    CODE_ALIGNMENT_ERROR
ENDIF
    ; Header for MOS
    defm    "MOS"
    defb    0     ;Version
    defb    0     ;ADL mode
ENDIF



start:
    defb 0x5b	;LIL
    push ix
    defb 0x5b	;LIL
    push iy
    INCLUDE "crt/classic/crt_start_eidi.inc"
    INCLUDE "crt/classic/crt_init_sp.asm"
    ; Make room for the atexit() stack
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

    ; Entry to the user code
    call    _main
    ; Exit code is in hl
cleanup:
    call    crt0_exit
    defb 0x5b	;LIL
    pop  iy
    defb 0x5b	;LIL
    pop  ix
    ld   hl,0
    defb 0
    defb $49 ;LIS
    ret


l_dcal:
    jp      (hl)



    INCLUDE "crt/classic/crt_runtime_selection.asm"

    ; If we were given a model then use it
IF DEFINED_CRT_MODEL
    defc __crt_model = CRT_MODEL
ENDIF
    INCLUDE	"crt/classic/crt_section.asm"

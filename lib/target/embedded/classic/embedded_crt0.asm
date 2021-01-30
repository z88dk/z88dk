;       Startup Code for Embedded Targets
;
;	Daniel Wallner March 2002
;


	DEFC	ROM_Start  = $0000
	DEFC	RAM_Start  = $8000
	DEFC	Stack_Top  = $ffff

	MODULE  embedded_crt0

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
ELSE
	defc	__crt_org_bss = RAM_Start
ENDIF

IF      !CRT_ORG_CODE
	defc	CRT_ORG_CODE = ROM_Start
ENDIF
	
	defc	TAR__register_sp = Stack_Top
        defc    TAR__clib_exit_stack_size = 32
	defc	__CPU_CLOCK = 4000000
	INCLUDE	"crt/classic/crt_rules.inc"


	org    	CRT_ORG_CODE

	jp	start
IF CRT_ORG_CODE = 0x0000
        defs    $0008-ASMPC
if (ASMPC<>$0008)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart08

        defs    $0010-ASMPC
if (ASMPC<>$0010)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart10

        defs    $0018-ASMPC
if (ASMPC<>$0018)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart18

        defs    $0020-ASMPC
if (ASMPC<>$0020)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart20

    defs        $0028-ASMPC
if (ASMPC<>$0028)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart28
        defs    $0030-ASMPC
if (ASMPC<>$0030)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart30

        defs    $0038-ASMPC
if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      asm_im1_handler

        defs    $0066-ASMPC
if (ASMPC<>$0066)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      asm_nmi_handler

; Restart routines, nothing sorted yet
restart08:
restart10:
restart18:
restart20:
restart28:
restart30:
        ret
ENDIF


start:
	INCLUDE	"crt/classic/crt_init_sp.asm"
	; Make room for the atexit() stack
	INCLUDE	"crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
	ld      (exitsp),sp

	; Entry to the user code
	call    _main
	; Exit code is in hl
cleanup:
        call    crt0_exit


endloop:
	jr	endloop
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

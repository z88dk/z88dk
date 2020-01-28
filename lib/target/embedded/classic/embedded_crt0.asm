;       Startup Code for Embedded Targets
;
;	Daniel Wallner March 2002
;
;	$Id: embedded_crt0.asm,v 1.19 2016-07-13 22:12:25 dom Exp $
;
; (DM) Could this do with a cleanup to ensure rstXX functions are
; available?

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
start:
; Make room for the atexit() stack
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
	ld      (exitsp),sp

; Entry to the user code
	call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
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

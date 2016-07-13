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
	DEFC	RAM_Length = $100
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



	org    ROM_Start

	jp	start
start:
; Make room for the atexit() stack
	ld	hl,Stack_Top-64
	ld	sp,hl
; Clear static memory
	ld	hl,RAM_Start
	ld	de,RAM_Start+1
	ld	bc,RAM_Length-1
	ld	(hl),0
	ldir
	call	crt0_init_bss
	ld      (exitsp),sp

; Entry to the user code
	call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF

endloop:
	jr	endloop
l_dcal:
	jp      (hl)


        INCLUDE "crt0_runtime_selection.asm"

	defc	__crt_org_bss = RAM_Start
        ; If we were given a model then use it
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF
	INCLUDE	"crt0_section.asm"

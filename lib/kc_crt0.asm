;
;       CRT0 for the Robotron KC85/2 .. KC85/5
;
;       Stefano Bodrato October 2016
;		few hints were found on the sdcc lib by Andreas Ziermann and Bert Lange
;
;
; - - - - - - -
;
;       $Id: kc_crt0.asm,v 1.1 2016-10-03 06:38:15 stefano Exp $
;
; - - - - - - -


	MODULE  kc_crt0

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


	IF      !DEFINED_CRT_ORG_CODE
			defc    CRT_ORG_CODE  = $0200
	ENDIF

	org     CRT_ORG_CODE


start:
	ld	(start1+1),sp	;Save entry stack
	
;	ld      hl,-64
;	add     hl,sp
;	ld      sp,hl
;	ld		sp,CRT_ORG_CODE
	
	call	crt0_init_bss
	ld      (exitsp),sp


; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF


	call    _main	;Call user program

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF

	pop	bc
start1:	ld	sp,0		;Restore stack to entry value
	; use call LOOP instead of ret, works also
	; with direct load+start on simulator
	call $f003	; PV1 - parameter in regs, PVnr after callPV1
	defb $12	;FNLOOP
	

l_dcal:	jp	(hl)		;Used for function pointer calls


	 defm  "Small C+ KC"	;Unnecessary file signature
	 defb	0

	INCLUDE "crt0_runtime_selection.asm"
	INCLUDE "crt0_section.asm"

	SECTION code_crt_init
	ld	hl,$8000
	ld	(base_graphics),hl


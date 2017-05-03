;       CRT0 for the Robotron Z1013
;
;       Stefano Bodrato August 2016
;
;
; - - - - - - -
;
;       $Id: z1013_crt0.asm,v 1.2 2016-10-10 07:09:14 stefano Exp $
;
; - - - - - - -


	MODULE  Z1013_crt0

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
			defc    CRT_ORG_CODE  = 100h
	ENDIF

	org     CRT_ORG_CODE

start:
	ld	(start1+1),sp	;Save entry stack

IF      STACKPTR
	ld  sp,STACKPTR
ELSE
	ld      sp,$dfff
ENDIF

;	ld      hl,-64
;	add     hl,sp
;	ld      sp,hl
	
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
	jp $F000

l_dcal:	jp	(hl)		;Used for function pointer calls


	 defm  "Small C+ Z1013"	;Unnecessary file signature
	 defb	0

	INCLUDE "crt0_runtime_selection.asm"
	INCLUDE "crt0_section.asm"
	SECTION code_crt_init
	ld	hl,$EC00
	ld	(base_graphics),hl


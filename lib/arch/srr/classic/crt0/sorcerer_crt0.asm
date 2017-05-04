;
;       Startup for Sorcerer Exidy
;
;       $Id: sorcerer_crt0.asm,v 1.15 2016-07-15 21:03:25 dom Exp $
;
; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma no-streams - No stdio disc files
;	#pragma no-fileio  - No fileio at all
;
;	These can cut down the size of the resultant executable

	MODULE  sorcerer_crt0

;-------------------------------------------------
; Include zcc_opt.def to find out some information
;-------------------------------------------------

        defc    crt0 = 1
	INCLUDE "zcc_opt.def"

;-----------------------
; Some scope definitions
;-----------------------

	EXTERN    _main		;main() is always external to crt0

	PUBLIC    cleanup		;jp'd to by exit()
	PUBLIC    l_dcal		;jp(hl)


;--------
; Set an origin for the application (-zorg=) default to 100h
;--------

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = 100h
        ENDIF

        org     CRT_ORG_CODE

;----------------------
; Execution starts here
;----------------------
start:
	ld      (start1+1),sp	;Save entry stack
	ld      hl,-64
	add     hl,sp
	ld      sp,hl
	call	crt0_init_bss
	ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF



        call    _main		;Call user code

cleanup:
	push	hl		;Save return value
IF !DEFINED_nostreams
	EXTERN	closeall	;Close any opened files
	call	closeall
ENDIF
	pop	bc		;Get exit() value into bc
start1:	ld      sp,0		;Pick up entry sp
        jp	$e003		; Monitor warm start

l_dcal:	jp	(hl)		;Used for call by function ptr



	defm  	"Small C+ Sorcerer"
end:	defb	0		; null file name

        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE	"crt0_section.asm"

	SECTION	code_crt_init
	ld	hl,$F080
	ld	(base_graphics),hl



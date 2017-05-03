;       CRT0 for the NASCOM1/2
;
;       Stefano Bodrato May 2003
;
;
; - - - - - - -
;
;       $Id: nascom_crt0.asm,v 1.23 2016-08-05 07:04:09 stefano Exp $
;
; - - - - - - -


	MODULE  nascom_crt0

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


	PUBLIC    montest         ;NASCOM: check the monitor type

	IF      !DEFINED_CRT_ORG_CODE
			defc    CRT_ORG_CODE  = 1000h
	ENDIF

	org     CRT_ORG_CODE

; NASSYS1..NASSYS3
;  IF (startup=1) | (startup=2) | (startup=3)
;
;
;  ENDIF

start:

	ld	(start1+1),sp	;Save entry stack

	ld	hl,0xe000
	ld      sp,hl
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
	rst	18h
	defb	5bh
	;ret

l_dcal:	jp	(hl)		;Used for function pointer calls


;------------------------------------
; Check which monitor we have in ROM
;------------------------------------

montest: ld	a,(1)	; "T" monitor or NAS-SYS?
         cp	33h	; 31 00 10     / 31 33 0C
         ret


         defm  "Small C+ NASCOM"	;Unnecessary file signature
         defb	0

        INCLUDE "crt0_runtime_selection.asm"
	INCLUDE "crt0_section.asm"


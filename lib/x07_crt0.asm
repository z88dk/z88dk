;
;       Startup for Canon X-07
;
;       $Id: x07_crt0.asm,v 1.11 2016-06-21 20:49:07 dom Exp $
;

	MODULE  x07_crt0

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
; Set an origin for the application (-zorg=) default to 800h
;--------

        IF      !myzorg
                defc    myzorg  = $800
        ENDIF

        org     myzorg

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


	ld a,65
	call $C1BE
        call    _main		;Call user code
	ld a,65
	call $C1BE

cleanup:
;	push	hl		;Save return value
IF !DEFINED_nostreams
	EXTERN	closeall	;Close any opened files
	call	closeall
ENDIF
;	pop	bc		;Get exit() value into bc

start1:	ld  sp,0    ;Pick up entry sp
        ret	        ; End of program

l_dcal:	jp  (hl)    ;Used for call by function ptr


	defm  	"Small C+ X-07"
end:	defb	0		; null file name

        INCLUDE "crt0_runtime_selection.asm"


	INCLUDE	"crt0_section.asm"

	SECTION	bss_crt
defltdsk:       defb    0	;Default disc
	PUBLIC	pixelbyte	; VDP gfx driver, byte temp storage
pixelbyte:	defb	0	; temp byte storage for VDP driver


;
; Init BASIC variables for file name and drive number
;
; Stefano - 13/7/2006
;
; Internal use only.
; To be called with HL pointing to the file name;
; This routine will eventually strip the header and update
; the 'D' BASIC variable with the drive number.
; N$ will always hold the file name
; The character specifying the current block is handled
;
; $Id: zxgetfname2.asm,v 1.4 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	zxgetfname2
	PUBLIC	_zxgetfname2
	
	EXTERN	zx_setint_callee
	EXTERN	zx_setstr_callee

	EXTERN ASMDISP_ZX_SETSTR_CALLEE
	EXTERN ASMDISP_ZX_SETINT_CALLEE


.zxgetfname2
._zxgetfname2
	;ld	e,(hl)		; pointer to file name
	;inc	hl
	;ld	d,(hl)

	ld	b,(hl)
	;ld	b,a

	inc	hl
	inc	hl
	ld	a,(hl)
	push hl
	cp	':'		; is a drive specified ?
	push af		; remember the character and the answer
	dec	hl
	dec hl
	jr	nz,default

	ld	a,(hl)
	cp	59
	jr	nc,nonum
	sub	48
	jr	wasnum
.nonum	and	95		; to upper
	sub	64		; now 'A' = drive 1, etc..
.wasnum	
	ld	c,a
	inc	hl		; now skip the first 2 chars ('a:' or similar)
	;ld	a,b
	ld	(hl),b	; well.. almost.  let's temporairly overwrite ':' with the first char in the block name
	;inc	hl
	jr	nodefault
.default
	ld	c,1		; force default: first drive
.nodefault

	;ld	b,0
	;ld	c,a

	push	hl
	ld	hl,dvar		; BASIC variable 'D'
	ld	d,0
	ld	e,c
	call	zx_setint_callee + ASMDISP_ZX_SETINT_CALLEE
	pop	hl
;	jr	drvnum
	

;.drvnum
	;ex	de,hl
	
	push hl
	ld	e,'N'		; n$
	call	zx_setstr_callee + ASMDISP_ZX_SETSTR_CALLEE
	pop hl

	pop	af
	pop	de
	;inc de
	;inc de
	ld	(de),a
	ret

; BASIC variable names for numeric values
	SECTION rodata_clib
.dvar	defb 'D',0

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
;
; $Id: zxgetfname.asm,v 1.5 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	zxgetfname
	PUBLIC	_zxgetfname
	
	EXTERN	zx_setint_callee
	EXTERN	zx_setstr_callee
	
	EXTERN ASMDISP_ZX_SETSTR_CALLEE
	EXTERN ASMDISP_ZX_SETINT_CALLEE



.zxgetfname
._zxgetfname
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
;	ld	e,(hl)		; pointer to file name
;	inc	hl
;	ld	d,(hl)

	inc	hl
	ld	a,(hl)
	cp	':'		; is a drive specified ?
	dec	hl
	jr	nz,default

	ld	a,(hl)
	cp	59
	jr	nc,nonum
	sub	48
	jr	wasnum
.nonum	and	95		; to upper
	sub	64		; now 'A' = drive 1, etc..
.wasnum	
	inc	hl		; now skip the first 2 chars ('a:' or similar)
	inc	hl
	jr	nodefault
.default
	ld	a,1		; force default: first drive
.nodefault

	;ld	b,0
	;ld	c,a

	push	af		; keep the "drive number", can be useful ;o)

	push	hl
	ld	hl,dvar		; BASIC variable 'D'
	;push	hl
	;push	bc
	ld	d,0
	ld	e,a
	call	zx_setint_callee + ASMDISP_ZX_SETINT_CALLEE
	;pop	bc
	;pop	hl
	pop	hl
;	jr	drvnum
	

;.drvnum
	;ld	h,0
	;ex	de,hl
	push hl
	ld	e,'N'		; n$
	;push	hl
	;push	de
	call	zx_setstr_callee + ASMDISP_ZX_SETSTR_CALLEE
	;pop	hl
	;pop	bc
	pop hl

	pop	af		; drive number (to check if printer, etc)

	ret

; BASIC variable names for numeric values
	SECTION rodata_clib
.dvar	defb 'D',0

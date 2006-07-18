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
; $Id: zxgetfname.asm,v 1.1 2006-07-18 21:02:54 stefano Exp $

	XLIB	zxgetfname
	
	LIB	zx_setint
	LIB	zx_setstr


; BASIC variable names for numeric values
.dvar	defb 'D',0

.zxgetfname
	ld	e,(hl)		; pointer to file name
	inc	hl
	ld	d,(hl)

	inc	de
	ld	a,(de)
	cp	':'		; is a drive specified ?
	dec	de
	jr	nz,default

	ld	a,(de)
	cp	59
	jr	nc,nonum
	sub	48
	jr	wasnum
.nonum	and	95		; to upper
	sub	64		; now 'A' = drive 1, etc..
.wasnum	
	inc	de		; now skip the first 2 chars ('a:' or similar)
	inc	de
	jr	nodefault
.default
	ld	a,1		; force default: first drive
.nodefault

	ld	b,0
	ld	c,a

	push	af		; keep the "drive number", can be useful ;o)

	push	de
	ld	hl,dvar		; BASIC variable 'D'
	push	hl
	push	bc
	call	zx_setint
	pop	bc
	pop	hl
	pop	de
	jr	drvnum
	

.drvnum
	ld	h,0
	ld	l,'N'		; n$
	push	hl
	push	de
	call	zx_setstr
	pop	hl
	pop	bc

	pop	af		; drive number (to check if printer, etc)

	ret


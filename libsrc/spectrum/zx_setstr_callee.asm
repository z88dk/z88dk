;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 29/06/2006
;
;	Copy a string to a BASIC variable
;
;	int __CALLEE__ zx_setstr_callee(char variable, char *value);
;
;
;	$Id: zx_setstr_callee.asm,v 1.1 2007-06-13 00:03:17 aralbrec Exp $
;

XLIB	zx_setstr_callee
XDEF	ASMDISP_ZX_SETSTR_CALLEE

zx_setstr_callee:

	pop	bc
	pop	hl
	pop	de
	push	bc

; enter : hl = char *value
;          e = char variable

.asmentry
	
	ld	a,e
	and	95
	
	ld	(morevar+1),a
	ld	(pointer+1),hl
	
	ld	hl,($5c4b) 		; VARS
	
loop:

	ld	a,(hl)
	cp	128
	jr	nz,morevar
	
	jr	store			; variable not found
	
morevar:

	cp	0
	jr	nz,nextvar
	
	call	$19b8			; get next variable start
	call	$19e8			; reclaim space (delete)
	
store:

	ld	bc,0

pointer:

	ld	de,0			; point to the string
	push	de

lenloop:

	inc	bc			; string length counter
	inc	de
	ld	a,(de)
	and	a
	jr	nz,lenloop
	
	push	hl
	push	bc	
	inc	bc
	inc	bc
	inc	bc
	call	$1655			; MAKE-ROOM
	pop	bc
	pop	hl
	
	ld	a,(morevar+1)
	ld	(hl),a
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	pop	de
	
	ex	de,hl
	ldir
	
	ret
	
nextvar:

	call	$19b8			;get next variable start
	ex	de,hl
	jr	loop

DEFC ASMDISP_ZX_SETSTR_CALLEE = asmentry - zx_setstr_callee

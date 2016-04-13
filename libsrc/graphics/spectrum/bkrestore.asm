;
;	Fast background restore
;
;	ZX Spectrum version (speeded up with a row table)
;
;	$Id: bkrestore.asm,v 1.5 2016-04-13 21:09:09 dom Exp $
;

	SECTION	  code_clib
	PUBLIC    bkrestore
	PUBLIC    _bkrestore
	EXTERN	zx_rowtab


.bkrestore
._bkrestore

; __FASTCALL__ : sprite ptr in HL
	push	ix
	push	hl
	pop	ix
	
	ld	d,(ix+2)
	ld	e,(ix+3)
	
	ld	a,d
	ld	d,0
	
	ld	hl,zx_rowtab
	add	hl,de
	add	hl,de
	ld	(actrow+1),hl	; save row table position
	
	ld	e,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,e
	
	push	af
	srl	a
	srl	a
	srl	a
	ld	(actcol+1),a
	ld	e,a
	pop	af

	add	hl,de
	
	ld	a,(ix+0)
	ld	b,(ix+1)
	
	dec	a
	srl	a
	srl	a
	srl	a
	inc	a
	inc	a		; INT ((Xsize-1)/8+2)
	ld	(rbytes+1),a
	di

.bkrestores
	push	bc
	
.rbytes
	ld	b,0
.rloop
	ld	a,(ix+4)
	ld	(hl),a
	inc	hl
	inc	ix
	djnz	rloop

	; ---------
.actrow
	ld	hl,0
	inc	hl
	inc	hl
	ld	(actrow+1),hl
	
	ld	b,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,b
.actcol
	ld	bc,0
	add	hl,bc
	; ---------

	pop	bc
	djnz	bkrestores
	ei
	pop	ix
	ret

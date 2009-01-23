;
;	Fast background restore
;
;	Generic version (just a bit slow)
;
;	$Id: bkrestore.asm,v 1.6 2009-01-23 13:48:11 stefano Exp $
;


	XLIB    bkrestore
	LIB	pixeladdress


.bkrestore

; __FASTCALL__ : sprite ptr in HL
	
	push	hl
	pop	ix

	ld	h,(ix+2)
	ld	l,(ix+3)

	push	hl
	call	pixeladdress
	pop	hl

	ld	a,(ix+0)
	ld	b,(ix+1)
	
	dec	a
	srl	a
	srl	a
	srl	a
	inc	a
	inc	a		; INT ((Xsize-1)/8+2)
	ld	(rbytes+1),a

.bkrestores
	push	bc
.rbytes
	ld	b,0
.rloop
	ld	a,(ix+4)
	ld	(de),a
	inc	de
	inc	ix
	djnz	rloop

	inc	l
	push	hl
	call	pixeladdress
	pop	hl
	
	pop	bc
	djnz	bkrestores
	ret

;
;	Fast background restore
;
;	MC-1000 version
;
;	$Id: bkrestore.asm,v 1.3 2013-03-27 12:51:22 stefano Exp $
;


	XLIB    bkrestore
	
	XREF	bkpixeladdress
	XREF	pix_return


.bkrestore

; __FASTCALL__ : sprite ptr in HL
	
	push	hl
	pop	ix

	ld	h,(ix+2)
	ld	l,(ix+3)

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

	call	bkpixeladdress

.rbytes
	ld	b,0
.rloop
	ld	a,(ix+4)
	;ld	(de),a
	call	pix_return
	inc	de
	inc	ix
	djnz	rloop

	inc	l
	
	pop	bc
	djnz	bkrestores
	ret

;
;	Fast background restore
;
;	MC-1000 version
;
;	$Id: bkrestore.asm,v 1.5 2016-06-21 20:16:35 dom Exp $
;

	SECTION	  code_clib
	PUBLIC    bkrestore
	PUBLIC    _bkrestore
	
	EXTERN	bkpixeladdress
	EXTERN	pix_return


.bkrestore
._bkrestore

; __FASTCALL__ : sprite ptr in HL
	push	ix	;save callers	
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
	pop	ix		;restore callers
	ret

;
; Fast background restore
;
; Graphics library for the Epson PX4
; Stefano - Nov 2015
;
; $Id: bkrestore.asm,v 1.3 2016-06-21 20:16:35 dom Exp $
;

	SECTION	code_clib
	PUBLIC    bkrestore
	PUBLIC    _bkrestore
	EXTERN	pixeladdress

	INCLUDE	"graphics/grafix.inc"

.bkrestore
._bkrestore

; __FASTCALL__ : sprite ptr in HL
	push	ix	;save callers
	push	hl
	pop	ix
	
	ld	h,(ix+2) ; restore sprite position
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

._sloop
	push	bc
	push	hl
	
.rbytes
	ld	b,0
.rloop
	ld	a,(ix+4)
	ld	(hl),a
	inc	hl
	inc	ix
	djnz	rloop

	pop	hl
    inc      h      ;Go to next line
	
	pop	bc
	djnz	_sloop
	pop	ix	;restore caller
	ret

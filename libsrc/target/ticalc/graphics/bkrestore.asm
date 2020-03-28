;
; Fast background restore
;
; TI calculators version
;
;
; $Id: bkrestore.asm,v 1.9 2017-01-02 22:57:59 aralbrec Exp $
;

	PUBLIC    bkrestore
   PUBLIC    _bkrestore
	EXTERN	cpygraph
	EXTERN	pixeladdress

	INCLUDE	"graphics/grafix.inc"

.bkrestore
._bkrestore

; __FASTCALL__ : sprite ptr in HL
	
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
	ld      bc,row_bytes      ;Go to next line
	add     hl,bc
	
	pop	bc
	djnz	_sloop
	jp	cpygraph

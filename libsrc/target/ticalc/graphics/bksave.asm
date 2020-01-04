;
; Fast background save
;
; TI calculators version
;
;
; $Id: bksave.asm,v 1.8 2017-01-02 22:57:59 aralbrec Exp $
;

	PUBLIC    bksave
   PUBLIC    _bksave
	EXTERN	pixeladdress

	INCLUDE	"graphics/grafix.inc"

.bksave
._bksave
        ld      hl,2   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
	push	de
	pop	ix

        inc     hl
        ld      e,(hl)  
 	inc	hl
        inc     hl
        ld      d,(hl)	; x and y __gfx_coords

	ld	h,d
	ld	l,e

	call	pixeladdress
	xor	7

	ld	h,d
	ld	l,e

	ld	(ix+2),h	; we save the current sprite position
	ld	(ix+3),l

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
	ld	a,(hl)
	ld	(ix+4),a
	inc	hl
	inc	ix
	djnz	rloop

	pop	hl
	ld      bc,row_bytes      ;Go to next line
	add     hl,bc
	
	pop	bc
	djnz	_sloop
	ret

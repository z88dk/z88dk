;
; Fast background restore
;
; TI calculators version
;
;
; $Id: bkrestore.asm,v 1.3 2001-04-18 13:21:38 stefano Exp $
;

	XLIB    bkrestore
	LIB	pixeladdress

	INCLUDE	"graphics/grafix.inc"

.bkrestore

        ld      hl,2   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
	push	de
	pop	ix
	
	ld	h,(ix+2) ; restore sprite position
	ld	l,(ix+3)

	ld	a,(ix+0)
	ld	b,(ix+1)
	cp	9
	jr	nc,bkrestore

._sloop
	push	bc
	push	hl
	
	ld	a,(ix+4)
	ld	(hl),a
	inc	hl
	ld	a,(ix+5)
	ld	(hl),a
	inc	ix
	inc	ix

	pop	hl
	ld      bc,row_bytes      ;Go to next line
	add     hl,bc
	
	pop	bc
	djnz	_sloop
	ret

.bkrestorew
	push	bc
	ld	a,(ix+4)
	ld	(hl),a
	inc	hl
	ld	a,(ix+5)
	ld	(hl),a
	inc	hl
	ld	a,(ix+6)
	ld	(hl),a
	inc	ix
	inc	ix
	inc	ix

	pop	hl
	ld      bc,row_bytes      ;Go to next line
	add     hl,bc
	
	pop	bc
	djnz	bkrestorew
	ret

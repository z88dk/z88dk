;
;	Fast background restore
;
;	Generic version (just a bit slow)
;
;	$Id: bkrestore.asm,v 1.3 2001-04-18 13:21:37 stefano Exp $
;


	XLIB    bkrestore
	LIB	pixeladdress


.bkrestore

        ld      hl,2   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
	push	de
	pop	ix

	ld	h,(ix+2)
	ld	l,(ix+3)

	push	hl
	call	pixeladdress
	pop	hl

	ld	a,(ix+0)
	ld	b,(ix+1)
	cp	9
	jr	nc,bkrestore

.bkrestores
	push	bc
	ld	a,(ix+4)
	ld	(de),a
	inc	de
	ld	a,(ix+5)
	ld	(de),a
	inc	ix
	inc	ix

	inc	l
	push	hl
	call	pixeladdress
	pop	hl
	
	pop	bc
	djnz	bkrestores
	ret

.bkrestorew
	push	bc
	ld	a,(ix+4)
	ld	(de),a
	inc	de
	ld	a,(ix+5)
	ld	(de),a
	inc	de
	ld	a,(ix+6)
	ld	(de),a
	inc	ix
	inc	ix
	inc	ix

	inc	l
	push	hl
	call	pixeladdress
	pop	hl
	
	pop	bc
	djnz	bkrestorew
	ret

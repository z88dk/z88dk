;
;	Fast background save
;
;	Generic version (just a bit slow)
;
;	$Id: bksave.asm,v 1.3 2001-04-18 13:21:37 stefano Exp $
;


	XLIB    bksave
	LIB	pixeladdress

.bksave
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
        ld      d,(hl)	; x and y coords

	ld	h,d	; current x coordinate
	ld	l,e	; current y coordinate

	ld	(ix+2),h
	ld	(ix+3),l

	push	hl
	call	pixeladdress
	pop	hl

	ld	a,(ix+0)
	ld	b,(ix+1)
	cp	9
	jr	nc,bksavew

.bksaves
	push	bc
	ld	a,(de)
	ld	(ix+4),a
	inc	de
	ld	a,(de)
	ld	(ix+5),a
	inc	ix
	inc	ix

	inc	l

	push	hl
	call	pixeladdress
	pop	hl
	
	pop	bc
	
	djnz	bksaves
	ret

.bksavew
	push	bc
	ld	a,(de)
	ld	(ix+4),a
	inc	de
	ld	a,(de)
	ld	(ix+5),a
	inc	de
	ld	a,(de)
	ld	(ix+6),a
	inc	ix
	inc	ix
	inc	ix

	inc	l

	push	hl
	call	pixeladdress
	pop	hl
	
	pop	bc
	djnz	bksavew
	ret

;
; Fast background save
;
; Generic version (just a bit slow)
;

	XLIB    bksave
	LIB	pixeladdress

	INCLUDE	"grafix.inc"

.actcoord
	 defw	0

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

	ld	h,d
	ld	l,e

	ld	(actcoord),hl	; save current coordinates

	ld	(ix+2),h
	ld	(ix+3),l

	call	pixeladdress
	xor	7

	ld	h,d
	ld	l,e

	ld	a,(ix+0)
	ld	b,(ix+1)
	cp	9
	jr	nc,bksavew

._sloop
	push	bc
	ld	a,(hl)
	ld	(ix+4),a
	inc	hl
	ld	a,(hl)
	ld	(ix+5),a
	inc	ix
	inc	ix

        ld	hl,(actcoord)
	inc	l
	ld	(actcoord),hl
	call	pixeladdress
	ld	h,d
	ld	l,e
	
	pop	bc
	
	djnz	_sloop
	ret

.bksavew
	push	bc
	ld	a,(hl)
	ld	(ix+4),a
	inc	hl
	ld	a,(hl)
	ld	(ix+5),a
	inc	hl
	ld	a,(hl)
	ld	(ix+6),a
	inc	ix
	inc	ix
	inc	ix

        ld	hl,(actcoord)
	inc	l
	ld	(actcoord),hl
	call	pixeladdress
	ld	h,d
	ld	l,e
	
	pop	bc
	djnz	bksavew
	ret

;
; Fast background restore
;
; Generic version (just a bit slow)
;

	XLIB    bkrestore
	LIB	pixeladdress

	INCLUDE	"grafix.inc"

.actcoord
	 defw	0

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

	ld	(actcoord),hl	; save current coordinates

	call	pixeladdress
	xor	7

	ld	h,d
	ld	l,e

	ld	a,(ix+0)
	ld	b,(ix+1)
	cp	9
	jr	nc,bkrestore

._sloop
	push	bc
	ld	a,(ix+4)
	ld	(hl),a
	inc	hl
	ld	a,(ix+5)
	ld	(hl),a
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

        ld	hl,(actcoord)
	inc	l
	ld	(actcoord),hl
	call	pixeladdress
	ld	h,d
	ld	l,e
	
	pop	bc
	djnz	bkrestorew
	ret

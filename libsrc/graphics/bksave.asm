;
;	Fast background save
;
;	Generic version (just a bit slow)
;
;	$Id: bksave.asm,v 1.7 2016-07-02 09:01:35 dom Exp $
;

	SECTION	  code_clib
	PUBLIC    bksave
	PUBLIC    _bksave
	EXTERN	pixeladdress


.bksave
._bksave
	push	ix
        ld      hl,4   
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

	ld	h,d	; current x coordinate
	ld	l,e	; current y coordinate

	ld	(ix+2),h
	ld	(ix+3),l

	push	hl
	call	pixeladdress
	pop	hl

	ld	a,(ix+0)
	ld	b,(ix+1)

	dec	a
	srl	a
	srl	a
	srl	a
	inc	a
	inc	a		; INT ((Xsize-1)/8+2)
	ld	(rbytes+1),a

.bksaves
	push	bc
	
.rbytes
	ld	b,0
.rloop
	ld	a,(de)
	ld	(ix+4),a
	inc	de
	inc	ix
	djnz	rloop

	inc	l
	push	hl
	call	pixeladdress
	pop	hl
	
	pop	bc
	
	djnz	bksaves
	pop	ix
	ret

;
;	Fast background area save
;
;	MC-1000 version
;
;	$Id: bksave.asm,v 1.6 2016-07-02 09:01:35 dom Exp $
;

	SECTION	code_clib
	PUBLIC    bksave
	PUBLIC    _bksave
	PUBLIC	bkpixeladdress
	EXTERN	gfxbyte_get
	EXTERN	pixelbyte

	
.bksave
._bksave
	push	ix		;save callers
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

	call	bkpixeladdress
	
.rbytes
	ld	b,0
.rloop
;-------
	push bc
	push hl
	ex	de,hl
	call gfxbyte_get
	ex	de,hl
	pop hl
	pop bc
	ld	a,(pixelbyte)
	
;-------	
	ld	(ix+4),a
	
	inc	de
	
	inc	ix
	djnz	rloop

	inc	l
	
	pop	bc
	djnz	bksaves
	pop	ix		;restore callers
	ret




.bkpixeladdress
	push hl
	; add y-times the nuber of bytes per line (32)
	; or just multiply y by 32 and the add
	ld	e,l
	ld	a,h
	ld	b,a

	ld	h,0

	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl

	ld	de,$8000
	add	hl,de

	; add x divided by 8
	
	;or	a
	rra
	srl a
	srl a
	ld	e,a
	ld	d,0
	add	hl,de	

	ex	de,hl
	pop	hl
	ret


;
;	Fast background save
;
;	PCW version
;	Stefano, 2021
;
;	$Id: w_bksave.asm $
;

IF !__CPU_INTEL__
	SECTION   smc_clib
	
	PUBLIC    bksave
	PUBLIC    _bksave
	
	EXTERN    w_pixeladdress
	EXTERN    swapgfxbk
	EXTERN    swapgfxbk1


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
        inc     hl
        ld      d,(hl)  ; y
        inc     hl
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
		ld		l,a		; x

;	ld	h,d	; current x coordinate
;	ld	l,e	; current y coordinate

	ld	(ix+2),l	; store x
	ld	(ix+3),h
	ld	(ix+4),e	; store y
	;ld	(ix+5),d
	ld		d,0

	ld		(x_coord+1),hl
	ld		c,e		; y coordinate
	
	push hl

	call swapgfxbk
	call	w_pixeladdress
	call swapgfxbk1

	pop hl	;x0

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
	call swapgfxbk
	ld	a,(de)
	ex	af,af
	call swapgfxbk1
	ex	af,af
	ld	(ix+6),a

	;inc	de
	ld	d,0
	ld	e,8
	add hl,de
	ld	e,c
	push hl
	call swapgfxbk
	call	w_pixeladdress
	call swapgfxbk1
	pop hl

	inc	ix
	djnz	rloop

	ld	d,0
	ld	e,c
	inc e	; y
.x_coord
	ld	hl,0
	push hl
	call swapgfxbk
	call	w_pixeladdress
	call swapgfxbk1
	pop hl
	
	pop	bc
	inc	c	; y
	
	djnz	bksaves
	pop	ix
	ret
ENDIF

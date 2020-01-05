;
;	Fast background save
;
;	TS2068 version
;	Stefano Bodrato, Spring 2019
;
;	$Id: w_bksave.asm $
;

	SECTION	  smc_clib
	PUBLIC    bksave
	PUBLIC    _bksave
	EXTERN	w_pixeladdress
	
		EXTERN     zx_saddrpdown

        EXTERN     swapgfxbk
        EXTERN    __graphics_end


.bksave
._bksave
	push	ix
	call    swapgfxbk
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

	call	w_pixeladdress
	ld	h,d
	ld	l,e
	ld	(saddr+1),hl
	;pop	bc

	ld	a,(ix+0)	; x size
	ld	b,(ix+1)	; y size

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
	ld	a,(hl)
	ld	(ix+6),a
	;--- Go to next byte ---
	 ld     a,h
	 xor    @00100000
	 cp     h
	 ld     h,a
	 jp     nc,gonehi
	 inc	hl
.gonehi
	;----
	inc	ix
	djnz	rloop

;---------
.saddr	ld hl,0
		call zx_saddrpdown
		ld	(saddr+1),hl
;---------

	pop	bc
	
	djnz	bksaves
	
	jp	__graphics_end

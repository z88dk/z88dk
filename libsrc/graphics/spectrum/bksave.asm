;
;	Fast background save
;
;	ZX Spectrum version (speeded up with a row table)
;
;	$Id: bksave.asm $
;

	SECTION smc_clib
	
	PUBLIC    bksave
	PUBLIC    _bksave

	EXTERN	pixeladdress
	EXTERN	zx_saddrpdown
	
	EXTERN     swapgfxbk
	EXTERN	__graphics_end



.bksave
._bksave
	push	ix
	call	swapgfxbk
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

	ld	(ix+2),d
	ld	(ix+3),e

	ld	h,d
	ld	l,e
	
	call	pixeladdress
	
	ld	h,d
	ld	l,e
	ld	(rowadr+1),hl
	
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
	ld	a,(hl)
	ld	(ix+4),a
	inc	hl
	inc	ix
	djnz	rloop

	; ---------
.rowadr
	ld	hl,0	; current address
	call	zx_saddrpdown
	ld	(rowadr+1),hl
	; ---------

	pop	bc
	
	djnz	bksaves
	
	jp	__graphics_end


;
;	Fast background restore
;
;	ZX Spectrum version (speeded up with a row table)
;
;	$Id: bkrestore.asm $
;

	SECTION smc_clib
	  

	EXTERN	pixeladdress
	EXTERN	zx_saddrpdown
	
	EXTERN     swapgfxbk
	EXTERN	__graphics_end
    PUBLIC    bkrestore
    PUBLIC    _bkrestore
    PUBLIC    bkrestore_fastcall
    PUBLIC    _bkrestore_fastcall

.bkrestore
._bkrestore
    pop de
    pop hl
    push hl
    push de

.bkrestore_fastcall
._bkrestore_fastcall
; __FASTCALL__ : sprite ptr in HL
	push	ix
	call	swapgfxbk
	push	hl
	pop	ix
	
	ld	d,(ix+2)
	ld	e,(ix+3)
	
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
	;di

.bkrestores
	push	bc
	
.rbytes
	ld	b,0
.rloop
	ld	a,(ix+4)
	ld	(hl),a
	inc	hl
	inc	ix
	djnz	rloop

	; ---------
.rowadr
	ld	hl,0	; current address
	call	zx_saddrpdown
	ld	(rowadr+1),hl

	pop	bc
	djnz	bkrestores
	
	;ei
	jp	__graphics_end

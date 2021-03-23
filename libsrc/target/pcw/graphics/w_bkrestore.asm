;
;	Fast background restore
;
;	PCW version
;	Stefano, 2021
;
;	$Id: w_bkrestore.asm $
;

IF !__CPU_INTEL__
	SECTION   smc_clib
	
	PUBLIC    bkrestore
	PUBLIC    _bkrestore
	
	EXTERN    w_pixeladdress
	EXTERN    swapgfxbk
	EXTERN    swapgfxbk1


.bkrestore
._bkrestore
	push	ix
; __FASTCALL__ : sprite ptr in HL
	
	push	hl
	pop	ix

	ld	l,(ix+2)	; x
	ld	h,(ix+3)
	ld	e,(ix+4)	; y
	;ld	d,(ix+5)
	ld		d,0
	
	ld		(x_coord+1),hl
	ld	c,e

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

.bkrestores
	push	bc
	
.rbytes
	ld	b,0
.rloop
	ld	a,(ix+6)
	ex af,af
	call swapgfxbk
	ex af,af
	ld	(de),a
	call swapgfxbk1

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
	inc c	; y
	
	djnz	bkrestores
	pop	ix
	ret
ENDIF

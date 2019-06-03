;
;	Fast background restore
;
;	TS2068 version
;	Stefano Bodrato, Spring 2019
;
;	$Id: w_bkrestore.asm $
;

	SECTION	  smc_clib
	PUBLIC    bkrestore
	PUBLIC    _bkrestore
	EXTERN	w_pixeladdress
	
		EXTERN     zx_saddrpdown

        EXTERN     swapgfxbk
        EXTERN    __graphics_end


.bkrestore
._bkrestore
	push	ix
; __FASTCALL__ : sprite ptr in HL
	
	push	hl
	call    swapgfxbk
	pop	ix

	ld	l,(ix+2)	; x
	ld	h,(ix+3)
	ld	e,(ix+4)	; y
	;ld	d,(ix+5)
	ld		d,0
	
	call	w_pixeladdress
	ld	h,d
	ld	l,e
	ld	(saddr+1),hl

	ld	a,(ix+0)	; x size
	ld	b,(ix+1)	; y size
	
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
	ld	(hl),a
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
	
	djnz	bkrestores
	
	jp	__graphics_end

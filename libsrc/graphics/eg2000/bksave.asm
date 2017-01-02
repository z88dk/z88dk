;
;		 Fast background save
;
;	 Colour Genie EG2000 version By Stefano Bodrato
;
;
; $Id: bksave.asm,v 1.4 2017-01-02 22:57:57 aralbrec Exp $
;

	SECTION   code_clib
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

	ld	h,d
	ld	l,e

	call	pixeladdress
	xor	7

	ld	h,d
	ld	l,e

	ld	(ix+2),h	; we save the current sprite position
	ld	(ix+3),l

	ld	a,(ix+0)
	ld	b,(ix+1)
	cp	9
	jr	nc,bksavew

._sloop
	push	bc
	push	hl
	ld	a,(hl)
	and	@10101010
	ld	(ix+4),a
	inc	hl
	ld	a,(hl)
	rra
	and	@01010101
	or	(ix+4)
	ld	(ix+4),a
	inc	hl
	
	ld	a,(hl)
	and	@10101010
	ld	(ix+5),a
	inc	hl
	ld	a,(hl)
	rra
	and	@01010101
	or	(ix+5)
	ld	(ix+5),a
	inc	hl

	inc	ix
	inc	ix

	pop	hl
	ld      bc,40      ;Go to next line
	add     hl,bc
	
	pop	bc
	
	djnz	_sloop
	pop	ix	;restore callers
	ret

.bksavew
	push	bc
	push	hl

	ld	a,(hl)
	and	@10101010
	ld	(ix+4),a
	inc	hl
	ld	a,(hl)
	rra
	and	@01010101
	or	(ix+4)
	ld	(ix+4),a
	inc	hl

	ld	a,(hl)
	and	@10101010
	ld	(ix+5),a
	inc	hl
	ld	a,(hl)
	rra
	and	@01010101
	or	(ix+5)
	ld	(ix+5),a
	inc	hl

	ld	a,(hl)
	and	@10101010
	ld	(ix+6),a
	inc	hl
	ld	a,(hl)
	rra
	and	@01010101
	or	(ix+6)
	ld	(ix+6),a

	inc	ix
	inc	ix
	inc	ix

	pop	hl
	ld	bc,40      ;Go to next line
	add	hl,bc
	
	pop	bc
	
	djnz	bksavew
	pop	ix	;restore callers
	ret

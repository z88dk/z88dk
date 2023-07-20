;
;       Colour Genie EG2000 graphics routines
;		 Fast background restore
;
;
; $Id: bkrestore.asm $
;

	SECTION   code_clib

	EXTERN	pixeladdress

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
	push	ix		;save callers	
	push	hl
	pop	ix

	ld	h,(ix+2) ; restore sprite position
	ld	l,(ix+3)

	ld	a,(ix+0)
	ld	b,(ix+1)
	cp	9
	jr	nc,bkrestore

._sloop
	push	bc
	push	hl
	
	ld	a,(ix+4)
	and	@10101010
	ld	(hl),a
	inc	hl
	ld	a,(ix+4)
	and	@01010101
	rla
	ld	(hl),a
	inc	hl

	ld	a,(ix+5)
	and	@10101010
	ld	(hl),a
	inc	hl
	ld	a,(ix+5)
	and	@01010101
	rla
	ld	(hl),a
	inc	hl

	inc	ix
	inc	ix

	pop	hl
	ld      bc,40      ;Go to next line
	add     hl,bc
	
	pop	bc
	djnz	_sloop
	jp __graphics_end
	

.bkrestorew
	push	bc

	ld	a,(ix+4)
	and	@10101010
	ld	(hl),a
	inc	hl
	ld	a,(ix+4)
	and	@01010101
	rla
	ld	(hl),a
	inc	hl

	ld	a,(ix+5)
	and	@10101010
	ld	(hl),a
	inc	hl
	ld	a,(ix+5)
	and	@01010101
	rla
	ld	(hl),a
	inc	hl

	ld	a,(ix+6)
	and	@10101010
	ld	(hl),a
	inc	hl
	ld	a,(ix+6)
	and	@01010101
	rla
	ld	(hl),a

	inc	ix
	inc	ix
	inc	ix

	pop	hl
	ld      bc,40      ;Go to next line
	add     hl,bc
	
	pop	bc
	djnz	bkrestorew
	jp __graphics_end

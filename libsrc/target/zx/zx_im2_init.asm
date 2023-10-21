
	SECTION	code_clib

	PUBLIC	zx_im2_init
	PUBLIC	_zx_im2_init
	PUBLIC	___zx_im2_init

	EXTERN	l_push_di
	EXTERN	l_pop_ei
	EXTERN	asm_im1_handler



; void zx_im2_init(void *table, uint8_t byte) __smallc
zx_im2_init:
_zx_im2_init:
___zx_im2_init:
	push	ix
	ld	ix,4
	add	ix,sp
	call	l_push_di
	; Setup jump table
	ld	l,0		;table
	ld	h,(ix+3)
	ld	a,h
	ld	i,a
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,257
	ld	a,(ix+0)	;byte
	ld	(hl),a
	ldir
	ld	l,a
	ld	h,a
	ld	(hl),195
	inc	hl
	ld	de,asm_im1_handler
	ld	(hl),e
	inc	hl
	ld	(hl),d
	im	2
	call	l_pop_ei
	pop	ix
	ret






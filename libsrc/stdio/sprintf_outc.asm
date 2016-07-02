	MODULE sprintf_outc
	SECTION	code_clib

	PUBLIC  sprintf_outc	
	EXTERN	fputc_cons


sprintf_outc:
	pop	bc
	pop	hl	;fp
	pop	de	;charcter
	push	bc
	push	ix	;save ix
	push	hl	;get fp into ix
	pop	ix

	ld	c,(ix+2)
	ld	b,(ix+3)
	ld	a,c
	or	b
	jr	z,no_space
	dec	bc		;reduce space
	ld	(ix+2),c
	ld	(ix+3),b
	ld	l,(ix+0)
	ld	h,(ix+1)
	ld	a,b		;make sure we can terminate
	or	c
	jr	z,just_terminate
	ld	(hl),e
	inc	hl
just_terminate:
	ld	(hl),0
	ld	(ix+0),l
	ld	(ix+1),h
no_space:
	pop	ix
	ret

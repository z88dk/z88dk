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
IF __CPU_R2K__ | __CPU_R3K__
	ld	ix,hl
ELSE
	push	hl	;get fp into ix
	pop	ix
ENDIF

	ld	c,(ix+2)
	ld	b,(ix+3)
	ld	a,c
	or	b
	jr	z,no_space
	dec	bc		;reduce space
	ld	(ix+2),c
	ld	(ix+3),b
IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(ix+0)
ELSE
	ld	l,(ix+0)
	ld	h,(ix+1)
ENDIF
	ld	a,b		;make sure we can terminate
	or	c
	jr	z,just_terminate
	ld	(hl),e
	inc	hl
just_terminate:
	ld	(hl),0
IF __CPU_R2K__ | __CPU_R3K__
	ld	(ix+0),hl
ELSE
	ld	(ix+0),l
	ld	(ix+1),h
ENDIF
no_space:
	pop	ix
	ret

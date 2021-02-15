
	SECTION	code_clib
	PUBLIC	fputc_cons_native
	PUBLIC	_fputc_cons_native

	EXTERN CHR4VID
	EXTERN CHAR2VID

.fputc_cons_native
._fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	10
	jr	nz,prchr
	ld	a,13
prchr:
    	ld	(CHR4VID),a
	call	CHAR2VID
	ret

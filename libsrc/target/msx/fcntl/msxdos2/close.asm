
		SECTION	code_clib
		INCLUDE	"target/msx/def/msxdos2.def"

		PUBLIC	close
		PUBLIC	_close
		EXTERN	MSXDOS
		EXTERN	msxdos_error

.close
._close
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	c,_CLOSE
	call	MSXDOS
	ld	(msxdos_error),a
	ld	hl,0
	and	a
	ret	z
	dec	hl
	ret

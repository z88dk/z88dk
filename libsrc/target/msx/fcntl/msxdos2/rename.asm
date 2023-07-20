                SECTION code_clib

		INCLUDE "target/msx/def/msxdos2.def"
		PUBLIC	rename
		PUBLIC	_rename
		PUBLIC	___rename

		EXTERN	MSXDOS
		EXTERN	msxdos_error

; (char *s, char *d)
.rename
._rename
.___rename
	pop	bc
	pop	hl	;dest
	pop	de	;src
	push	de
	push	hl
	push	bc

	ld	c,_RENAME
	call	MSXDOS
	ld	(msxdos_error),a
	ld	hl,0
	and	a
	ret	z
	dec	hl
	ret

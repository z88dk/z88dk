	SECTION	code_clib

	INCLUDE	"target/msx/def/msxdos2.def"

	PUBLIC	chdir
	PUBLIC	_chdir

	EXTERN	MSXDOS
	EXTERN	msxdos_error

; (char *)
chdir:
_chdir:
	pop	bc
	pop	de	;directory
	push	de
	push	bc
	ld	c,_CHDIR
	call	MSXDOS
	ld	(msxdos_error),a
	ld	hl,0
	and	a
	ret	z
	dec	hl
	ret
	

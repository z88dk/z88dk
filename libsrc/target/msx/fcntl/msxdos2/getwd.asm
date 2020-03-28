	SECTION	code_clib

	INCLUDE	"target/msx/def/msxdos2.def"

	PUBLIC	getwd
	PUBLIC	_getwd

	EXTERN	MSXDOS
	EXTERN	msxdos_error

; (char *)
getwd:
_getwd:
	pop	bc
	pop	de	;64 byte buffer
	push	de
	push	bc
	ld	c,_GETCD
	call	MSXDOS
	ld	(msxdos_error),a
	ld	hl,0
	and	a
	ret	z
	dec	hl
	ret
	

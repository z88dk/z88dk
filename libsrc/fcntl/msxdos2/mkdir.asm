	SECTION	code_clib

	INCLUDE	"target/msx/def/msxdos2.def"

	PUBLIC	mkdir
	PUBLIC	_mkdir

	EXTERN	MSXDOS
	EXTERN	msxdos_error

; (char *)
mkdir:
_mkdir:
	pop	bc
	pop	de	;directory name
	push	de
	push	bc
	xor	a		;open mode
	ld	b,@00010000	;Directory
	ld	c,_CREATE
	call	MSXDOS
	ld	(msxdos_error),a
	ld	hl,0
	and	a
	ret	z
	dec	hl
	ret

	

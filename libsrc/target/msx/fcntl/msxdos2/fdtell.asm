        SECTION code_clib

	PUBLIC	fdtell
	PUBLIC	_fdtell

	INCLUDE	"target/msx/def/msxdos2.def"
	EXTERN	MSXDOS
	EXTERN	msxdos_error

.fdtell
._fdtell
	pop	af
	pop	bc	;File handler
	push	bc
	push	af

	ld	hl,0
	ld	de,0
	ld	a,1
	ld	c,_SEEK
	call	MSXDOS
	ld	(msxdos_error),a
	and	a
	ret	z
	ld	hl,-1	;return -1
	ld	d,h
	ld	e,l
	ret


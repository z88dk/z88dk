                SECTION code_clib

		INCLUDE "target/msx/def/msxdos2.def"

		PUBLIC	readbyte
		PUBLIC	_readbyte

		EXTERN	MSXDOS
		EXTERN	msxdos_error
		
.readbyte
._readbyte
	ld	b,h		;fd
	ld	hl,0
	push	hl
	add	hl,sp
	ex	de,hl
	ld	hl,1
	ld	c,_READ
	call	MSXDOS
	ld	(msxdos_error),a
	pop	hl
	and	a
	ret	z
	ld	hl,-1
	ret

                SECTION code_clib
                INCLUDE "target/msx/def/msxdos2.def"

		PUBLIC	write
		PUBLIC	_write
                EXTERN  MSXDOS
                EXTERN  msxdos_error


; (fd, buf,len)
.write
._write
	pop	af	;ret
	pop	hl	;len
	pop	de	;buf
	pop	bc	;b = fd
	push	bc
	push	de
	push	hl
	push	af
	ld	c,_WRITE
	call	MSXDOS
	ld	(msxdos_error),a
	and	a
	ret	z
	ld	hl,-1
	ret

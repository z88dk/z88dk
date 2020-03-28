                SECTION code_clib
                INCLUDE "target/msx/def/msxdos2.def"

		PUBLIC	read
		PUBLIC	_read
                EXTERN  MSXDOS
                EXTERN  msxdos_error


; (fd, buf,len)
.read
._read
	pop	af	;ret
	pop	hl	;len
	pop	de	;buf
	pop	bc	;b = fd
	push	bc
	push	de
	push	hl
	push	af
	ld	c,_READ
	call	MSXDOS
	ld	(msxdos_error),a
	and	a
	ret	z
	ld	hl,-1
	ret

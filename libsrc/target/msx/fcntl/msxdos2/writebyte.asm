                SECTION code_clib

		INCLUDE	"target/msx/def/msxdos2.def"
		PUBLIC	writebyte
		PUBLIC	_writebyte

		EXTERN	MSXDOS
		EXTERN	msxdos_error


;(int fd, int b)
.writebyte
._writebyte
	push	ix
	ld	ix,4
	add	ix,sp

	ld	b,(ix+3)
	ld	hl,4
	add	hl,sp
	ex	de,hl
	ld	hl,1
	ld	c,_WRITE
	call	MSXDOS
	ld	(msxdos_error),a
	pop	ix
	ld	l,(ix+0)
	ld	h,(ix+1)
	and	a
	ret	z
	ld	hl,-1
	ret


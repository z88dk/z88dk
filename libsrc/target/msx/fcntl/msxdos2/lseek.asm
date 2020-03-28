
        SECTION code_clib


	INCLUDE "target/msx/def/msxdos2.def"

	PUBLIC	lseek
	PUBLIC	_lseek

	EXTERN	MSXDOS
	EXTERN	msxdos_error

; fd, where, whence
.lseek
._lseek
        push    ix              ;save callers
        ld      ix,2
        add     ix,sp

	ld	a, (ix + 2)	;whence
	ld	b, (ix + 9)	;fd

	ld	l, (ix + 4)
	ld	h, (ix + 5)
	ld	e, (ix + 6)
	ld	d, (ix + 7)
	ld	c,_SEEK
	call	MSXDOS
	ld	(msxdos_error),a
	pop	ix
	ret

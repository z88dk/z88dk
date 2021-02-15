	SECTION	code_clib

	INCLUDE	"target/msx/def/msxdos2.def"

	PUBLIC	getcwd
	PUBLIC	_getcwd

	EXTERN	MSXDOS
	EXTERN	msxdos_error

; (char *,size_t len)
getcwd:
_getcwd:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	hl,-64
	add	hl,sp
	ld	sp,hl
	ex	de,hl	;de = buffer
	push	ix
	ld	c,_GETCD
	call	MSXDOS
	ld	(msxdos_error),a
	pop	ix
	and	a
	jr	nz,skip_copy
	ld	c,(ix+4)	;length
	ld	b,(ix+5)
	ld	e,(ix+6)	;destination
	ld	d,(ix+7)
	ld	hl,0
	add	hl,sp
	ldir
skip_copy:
	ld	hl,64
	add	hl,sp
	ld	sp,hl
	pop	ix
	ld	hl,0
	and	a	
	ret	z
	dec	hl
	ret


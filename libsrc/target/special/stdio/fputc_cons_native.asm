
	SECTION	code_clib

	PUBLIC	fputc_cons_native
	PUBLIC	_fputc_cons_native

	INCLUDE	"target/special/def/special.def"

fputc_cons_native:
_fputc_cons_native:
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	10
	jr	nz,not_lf
	ld	c,13
	call	CONSOLE_OUT
not_lf:
	ld	c,(hl)
	call	CONSOLE_OUT
	ret

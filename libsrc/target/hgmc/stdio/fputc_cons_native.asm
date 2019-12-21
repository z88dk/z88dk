
	SECTION	code_clib

	PUBLIC	fputc_cons_native
	PUBLIC	_fputc_cons_native

	INCLUDE	"target/hgmc/def/hgmc.def"

fputc_cons_native:
_fputc_cons_native:
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	call	CONSOLE_OUT
	ret

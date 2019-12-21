
	SECTION	code_clib

	PUBLIC	fputc_cons_native
	PUBLIC	_fputc_cons_native

	INCLUDE	"target/kramermc/def/kramermc.def"

fputc_cons_native:
_fputc_cons_native:
	ld	hl,2
	add	hl,sp
	ld	c,(hl)
	call	CONSOLE_OUT
	ret

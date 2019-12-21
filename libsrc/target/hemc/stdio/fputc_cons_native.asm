
	SECTION	code_clib

	PUBLIC	fputc_cons_native
	PUBLIC	_fputc_cons_native

	INCLUDE	"target/hemc/def/hemc.def"

fputc_cons_native:
_fputc_cons_native:
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	10
	jr	nz,continue
	ld	c,13	
	call	CONSOLE_OUT
continue:
	ld	c,(hl)
	call	CONSOLE_OUT
	ret

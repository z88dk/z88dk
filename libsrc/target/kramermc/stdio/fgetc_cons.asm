
	SECTION	code_clib

	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

	INCLUDE	"target/kramermc/def/kramermc.def"

fgetc_cons:
_fgetc_cons:
	call	CONSOLE_IN
	ld	l,a
	ld	h,0
	ret


	SECTION	code_clib

	PUBLIC	getk
	PUBLIC	_getk
	EXTERN	fgetc_cons

	INCLUDE	"target/kramermc/def/kramermc.def"

getk:
_getk:
	halt
	call	CONSOLE_STAT
	ld	hl,0
	and	a
	ret	z
	jp	fgetc_cons

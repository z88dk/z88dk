
	SECTION	code_clib

	PUBLIC	getk
	PUBLIC	_getk

	EXTERN	fgetc_cons

	INCLUDE	"target/hemc/def/hemc.def"

getk:
_getk:
	call	CONSOLE_STAT
	ld	hl,0
	ret	z
	jp	fgetc_cons

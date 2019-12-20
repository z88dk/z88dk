
	SECTION	code_clib

	PUBLIC	getk
	PUBLIC	_getk

	INCLUDE	"target/hemc/def/hemc.def"

getk:
_getk:
	call	CONSOLE_STAT
	ld	hl,0
	ret	z
	ld	l,a
	ret

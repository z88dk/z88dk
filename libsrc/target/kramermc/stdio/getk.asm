
	SECTION	code_clib

	PUBLIC	getk
	PUBLIC	_getk

	INCLUDE	"target/kramermc/def/kramermc.def"

getk:
_getk:
	call	CONSOLE_STAT
	ld	hl,0
	and	a
	ret	z
	call	CONSOLE_IN
	ld	l,a
	ld	h,0
	ret

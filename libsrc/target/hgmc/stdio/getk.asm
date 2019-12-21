
	SECTION	code_clib

	PUBLIC	getk
	PUBLIC	_getk

	INCLUDE	"target/hgmc/def/hgmc.def"

getk:
_getk:
	call	CONSOLE_STAT
	ld	hl,0
	ret	z
IF STANDARDESCAPECHARS
        cp      13
        jr      nz,not_return
        ld      a,10
.not_return
ENDIF
	ld	l,a
	ret

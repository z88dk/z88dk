
	SECTION	code_clib

	PUBLIC	getk
	PUBLIC	_getk

	EXTERN	fgetc_cons

	INCLUDE	"target/hgmc/def/hgmc.def"

getk:
_getk:
	ld	hl,0
	in	a,(PORT_KBD_STATUS)
	and	a
	ret	z
	in	a,(PORT_KBD_DATA)
IF STANDARDESCAPECHARS
        cp      13
        jr      nz,not_return
        ld      a,10
.not_return
ENDIF
	ld	l,a
	ld	h,0
	ret


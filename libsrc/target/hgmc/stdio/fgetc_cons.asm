
	SECTION	code_clib

	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

	INCLUDE	"target/hgmc/def/hgmc.def"

fgetc_cons:
_fgetc_cons:
	call	CONSOLE_IN
IF STANDARDESCAPECHARS
        cp      13
        jr      nz,not_return
        ld      a,10
.not_return
ENDIF
	ld	l,a
	ld	h,0
	ret

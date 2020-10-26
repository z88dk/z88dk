
		SECTION code_clib
		PUBLIC	getk
		PUBLIC	_getk

                INCLUDE  "target/lm80c/def/lm80c.def"

.getk
._getk
	ld	h,0
	ld	a,(LASTKEYPRSD)
	ld	l,a
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	l,10
.not_return
ENDIF
	xor	a
	ld	(LASTKEYPRSD),a
	ret

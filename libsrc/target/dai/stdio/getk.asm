

	SECTION	code_clib
	PUBLIC	getk
	PUBLIC	_getk

	INCLUDE	"target/dai/def/dai.def"

.getk
._getk
	call	dai_GETK
	ld	l,a
	ld	h,0
	ret

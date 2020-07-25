

	SECTION	code_clib
	PUBLIC	getk
	PUBLIC	_getk

	INCLUDE	"target/dai/def/dai.def"

.getk
._getk
	call	dai_GETK
	ld	l,a
	ld	h,0
	and	a
	ret	z
	cp	13
	ret	nz
	ld	l,10
	ret


	SECTION	code_clib

	PUBLIC	getk
	PUBLIC	_getk

	EXTERN	fgetc_cons

getk:
_getk:
	ld	hl,0
	in	a,(0)
	and	1
	ret	nz
	in	a,(1)
	and	127
	ld	l,a
	ret

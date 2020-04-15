        MODULE    getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	  __zx_screenmode
	EXTERN    __console_w

.getmaxx
._getmaxx
	ld	a,(__zx_screenmode)
	ld	hl,255
	cp	3
	ret	c
	ld	hl,511
	and	7
	cp	6
	ret	z
	; So we must be left with a ZXN screenmode
	ld	hl,(__console_w)
	ld	h,0
	add	hl,hl
	dec	hl
	ret

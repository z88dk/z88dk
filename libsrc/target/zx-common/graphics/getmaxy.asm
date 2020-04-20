
        MODULE    getmaxy
        SECTION   code_clib
        PUBLIC    getmaxy
        PUBLIC    _getmaxy
	EXTERN	__zx_screenmode
	EXTERN	__console_h

.getmaxy
._getmaxy
        ld      a,(__zx_screenmode)
	ld	hl,191
	cp	3
	ret	c
	and	7
	cp	6
	ret	z
	; And so we're left with ZXN
	ld	hl,(__console_h)
	ld	h,0
	add	hl,hl
	dec	hl
	ret	

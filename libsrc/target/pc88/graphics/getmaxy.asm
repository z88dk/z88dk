
        MODULE  pc88_getmaxy
        SECTION code_clib
        PUBLIC  getmaxy
        PUBLIC  _getmaxy
        EXTERN  __console_h
        EXTERN  __pc88_gfxmode



.getmaxy
._getmaxy
        ld      a,(__pc88_gfxmode)
	ld	hl,199
	and	a
	ret	z
        ; We must be in lores mode here
        ld      a,(__console_h)
	add	a
	add	a
	dec	a
	ld	l,a
	ld	h,0
	ret

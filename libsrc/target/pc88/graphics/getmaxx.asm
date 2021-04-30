	INCLUDE	"graphics/grafix.inc"


        MODULE    pc88_getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	  __pc88_gfxmode
	EXTERN	__console_w

.getmaxx
._getmaxx
	ld	a,(__pc88_gfxmode)
	ld	hl,639
	and	a
	ret	z
	; We must be in lores mode here
	ld	a,(__console_w)
	add	a
	dec	a
	ld	l,a
	ld	h,0
	ret

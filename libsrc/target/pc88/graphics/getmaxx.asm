	INCLUDE	"graphics/grafix.inc"


        MODULE    pc88_getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	  __pc88_gfxmode
	EXTERN	  __console_w
        EXTERN    __gfx_fatpix

.getmaxx
._getmaxx
	; We must be in lores mode here
	ld	a,(__console_w)
	add	a
	dec	a
	ld	l,a
	ld	h,0
	ld	a,(__pc88_gfxmode)
        and     a
        ret     nz
        ld      hl,319
        ld      a,(__gfx_fatpix)
        and     a
        ret     nz
        ld      hl,639
	ret

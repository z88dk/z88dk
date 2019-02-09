
        MODULE   __tms9918_getmaxx
        SECTION  code_clib
        PUBLIC   __tms9918_getmaxx
	EXTERN	 __tms9918_screen_mode

	INCLUDE	"graphics/grafix.inc"
	INCLUDE	"video/tms9918/vdp.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
        PUBLIC  getmaxx
        PUBLIC  _getmaxx
        defc    getmaxx = __tms9918_getmaxx
	defc	_getmaxx = getmaxx
ENDIF

.__tms9918_getmaxx
	ld	a,(__tms9918_screen_mode)
	and	a
	ld	hl, +63
	ret	z
	ld	hl, +79
	dec	a
	ret	z
	ld	hl,255
	ret

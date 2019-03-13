

        MODULE   __tms9918_getmaxx
        SECTION  code_clib
        PUBLIC   __tms9918_getmaxy
        EXTERN   __tms9918_screen_mode

	INCLUDE	"graphics/grafix.inc"
	INCLUDE	"video/tms9918/vdp.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
        PUBLIC  getmaxy
        PUBLIC  _getmaxy
        defc    getmaxy = __tms9918_getmaxy
        defc    _getmaxy = getmaxy
ENDIF

.__tms9918_getmaxy
        ld      a,(__tms9918_screen_mode)
        and     a
        ld      hl, 47
        ret     z
        dec     a
        ret     z
        ld      hl, 191
        ret


    MODULE   __tms9918_getmaxx
    SECTION  code_video_vdp
    PUBLIC   __tms9918_getmaxx
    EXTERN  __tms9918_gfxw

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/tms9918/vdp.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    defc    getmaxx = __tms9918_getmaxx
    defc	_getmaxx = getmaxx
ENDIF

.__tms9918_getmaxx
    ld      hl,(__tms9918_gfxw)
    ld      h,0
    ret



    MODULE   __tms9918_getmaxx
    SECTION  code_video_vdp
    PUBLIC   __tms9918_getmaxy
    EXTERN   __tms9918_gfxh

    INCLUDE	"graphics/grafix.inc"
    INCLUDE	"video/tms9918/vdp.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
    PUBLIC  getmaxy
    PUBLIC  _getmaxy
    defc    getmaxy = __tms9918_getmaxy
    defc    _getmaxy = getmaxy
ENDIF

.__tms9918_getmaxy
    ld      hl,(__tms9918_gfxh)
    ld      h,0
    ret
    
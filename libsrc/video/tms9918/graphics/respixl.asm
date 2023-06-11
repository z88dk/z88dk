
    MODULE  __tms9918_respixel
    SECTION code_video_vdp
    PUBLIC  __tms9918_respixel

    EXTERN  __tms9918_graphics_res

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/tms9918/vdp.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
    PUBLIC  respixel
    defc    respixel = __tms9918_respixel
ENDIF



; ******************************************************************
;
; Reset plot pixel at (x,y) coordinate.
;
; in:  hl = (x,y) coordinate of pixel (h,l)

.__tms9918_respixel
    ex      de,hl
    ld      hl,(__tms9918_graphics_res)
    jp      (hl)

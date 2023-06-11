
    MODULE  __tms9918_xorpixel
    SECTION code_video_vdp
    PUBLIC  __tms9918_xorpixel

    EXTERN  __tms9918_graphics_xor

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/tms9918/vdp.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
    PUBLIC  xorpixel
    defc    xorpixel = __tms9918_xorpixel
ENDIF



; ******************************************************************
;
; Xor plot pixel at (x,y) coordinate.
;
; in:  hl = (x,y) coordinate of pixel (h,l)

.__tms9918_xorpixel
    ex      de,hl
    ld      hl,(__tms9918_graphics_xor)
    jp      (hl)

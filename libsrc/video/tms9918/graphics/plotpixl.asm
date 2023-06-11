
    MODULE  __tms9918_plotpixel
    SECTION code_video_vdp
    PUBLIC  __tms9918_plotpixel

    EXTERN  __tms9918_graphics_plot

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/tms9918/vdp.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
    PUBLIC  plotpixel
    defc    plotpixel = __tms9918_plotpixel
ENDIF



; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; in:  hl = (x,y) coordinate of pixel (h,l)
.__tms9918_plotpixel
    ex      de,hl
    ld      hl,(__tms9918_graphics_plot)
    jp      (hl)

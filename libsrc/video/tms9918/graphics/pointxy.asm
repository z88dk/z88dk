
    MODULE  __tms9918_pointxy
    SECTION code_video_vdp
    PUBLIC  __tms9918_pointxy

    EXTERN  __tms9918_graphics_point

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/tms9918/vdp.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
    PUBLIC  pointxy
    defc    pointxy = __tms9918_pointxy
ENDIF



; ******************************************************************
;
; Check if pixel at        (x,y) coordinate is        set or not.
;  in:        hl =        (x,y) coordinate of pixel to test
; out:        Fz =        0, if pixel is set, otherwise Fz = 1.

.__tms9918_pointxy
    ex      de,hl
    ld      hl,(__tms9918_graphics_point)
    jp      (hl)

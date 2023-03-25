SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_undraw

EXTERN  __tms9918_attribute
EXTERN  __v9938_draw_line


__v9938_undraw:
    ld      a,(__tms9918_attribute)
    and     15
    ld      b,a
    ld      a,V9938_LOGIC_SET
    jp      __v9938_draw_line

ENDIF
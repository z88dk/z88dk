SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_4bpp_undraw
PUBLIC  __v9938_8bpp_undraw

EXTERN  __tms9918_attribute
EXTERN  __tms9918_8bpp_attr
EXTERN  __v9938_draw_line

__v9938_8bpp_undraw:
    ld      a,(__tms9918_8bpp_attr+1)
    jr      do_draw

__v9938_4bpp_undraw:
    ld      a,(__tms9918_attribute)
    and     15
do_draw:
    ld      b,a
    ld      a,V9938_LOGIC_SET
    jp      __v9938_draw_line

ENDIF
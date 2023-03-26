SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_4bpp_xordraw
PUBLIC  __v9938_8bpp_xordraw

EXTERN  __tms9918_attribute
EXTERN  __tms9918_8bpp_attr
EXTERN  __v9938_draw_line



__v9938_8bpp_xordraw:
    ld      a,(__tms9918_8bpp_attr)
    jr      do_draw

__v9938_4bpp_xordraw:
    ld      a,(__tms9918_attribute)
    rrca
    rrca
    rrca
    rrca
    and     15
do_draw:
    ld      b,a
    ld      a,V9938_LOGIC_XOR
    jp      __v9938_draw_line
    
ENDIF
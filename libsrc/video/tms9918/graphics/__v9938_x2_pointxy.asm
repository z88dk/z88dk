SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_x2_pointxy
EXTERN  __v9938_point
EXTERN  __tms9918_2bpp_attr

__v9938_x2_pointxy:
    ex      de,hl
    ld      de,0
    and     a
    rl      h
    rl      d
    call    __v9938_point
    ld      l,a
    ld      a,(__tms9918_2bpp_attr+1)   ;paper
    rlca
    rlca
    and     3
    cp      l
    ret     z
    ld      a,l
    and     a
    ret
ENDIF
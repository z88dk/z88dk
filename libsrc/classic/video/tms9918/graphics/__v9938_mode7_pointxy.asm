    SECTION code_video_vdp

    INCLUDE "classic/video/tms9918/vdp.inc"

IFDEF   V9938

    PUBLIC  __v9938_mode7_pointxy
    EXTERN  __v9938_point
    EXTERN  __tms9918_attribute

__v9938_mode7_pointxy:
    ex      de, hl
    ld      de, 0
    and     a
    rl      h
    rl      d
    call    __v9938_point
    ld      l, a
    ld      a, (__tms9918_attribute)  ;paper
    and     15
    cp      l
    ret     z
    ld      a, l
    and     a
    ret
ENDIF

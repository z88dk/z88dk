SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_pointxy
EXTERN  __v9938_point
EXTERN  __tms9918_attribute

__v9938_pointxy:
    ex      de,hl
    ld      de,0
    call    __v9938_point
    ld      l,a
    ld      a,(__tms9918_attribute)
    and     15
    cp      l
    ret     z
    ld      a,l
    and     a
    ret

ENDIF
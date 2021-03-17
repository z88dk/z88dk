    SECTION code_clib
    PUBLIC  w_pointxy


    EXTERN  pointxy_MODE0
    EXTERN  pointxy_MODE2
    EXTERN  pointxy_MODE3
    EXTERN  pointxy_MODE4
    EXTERN  __zx_screenmode
    defc    NEEDpointxy = 1


w_pointxy:
    ld      a,(__zx_screenmode)
    and     a
    jp      z,pointxy_MODE0
    dec     a
    jp      z,pointxy_MODE2
    dec     a
    jp      z,pointxy_MODE3
    jp      pointxy_MODE4
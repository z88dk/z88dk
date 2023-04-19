    SECTION code_clib
    PUBLIC  w_pointxy


    EXTERN  pointxy_MODE0
    EXTERN  pointxy_MODE1
    EXTERN  pointxy_MODE2
    EXTERN  __cpc_mode
    defc    NEEDpointxy = 1


w_pointxy:
    ld      a,d      ;Check y
    and     a
    ret     nz
    ld      a,e
    cp      200
    ret     nc
    ld      a,(__cpc_mode)
    and     a
    jp      z,pointxy_MODE0
    dec     a
    jp      z,pointxy_MODE1
    jp      pointxy_MODE2
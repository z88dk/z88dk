    SECTION code_clib
    PUBLIC  w_respixel


    EXTERN  res_MODE0
    EXTERN  res_MODE1
    EXTERN  res_MODE2
    EXTERN  __cpc_mode
    defc    NEEDres = 1


w_respixel:
    ld      a,d      ;Check y
    and     a
    ret     nz
    ld      a,e
    cp      200
    ret     nc
    ld      a,(__cpc_mode)
    and     a
    jp      z,res_MODE0
    dec     a
    jp      z,res_MODE1
    jp      res_MODE2
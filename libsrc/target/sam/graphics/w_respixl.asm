    SECTION code_clib
    PUBLIC  w_respixel


    EXTERN  res_MODE0
    EXTERN  res_MODE2
    EXTERN  res_MODE3
    EXTERN  res_MODE4
    EXTERN  __zx_screenmode
    defc    NEEDres = 1


w_respixel:
    ld      a,(__zx_screenmode)
    and     a
    jp      z,res_MODE0
    dec     a
    jp      z,res_MODE2
    dec     a
    jp      z,res_MODE3
    jp      res_MODE4
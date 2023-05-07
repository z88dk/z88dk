    SECTION code_clib
    PUBLIC  w_plotpixel


    EXTERN  plot_MODE0
    EXTERN  plot_MODE1
    EXTERN  plot_MODE2
    EXTERN  __cpc_mode
    defc    NEEDplot = 1


w_plotpixel:
    ld      a,d      ;Check y
    and     a
    ret     nz
    ld      a,e
    cp      200
    ret     nc
    ld      a,(__cpc_mode)
    and     a
    jp      z,plot_MODE0
    dec     a
    jp      z,plot_MODE1
    jp      plot_MODE2
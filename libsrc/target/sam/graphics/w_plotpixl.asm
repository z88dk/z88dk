    SECTION code_clib
    PUBLIC  w_plotpixel


    EXTERN  plot_MODE0
    EXTERN  plot_MODE2
    EXTERN  plot_MODE3
    EXTERN  plot_MODE4
    EXTERN  __zx_screenmode
    defc    NEEDplot = 1


w_plotpixel:
    ld      a,(__zx_screenmode)
    and     a
    jp      z,plot_MODE0
    dec     a
    jp      z,plot_MODE2
    dec     a
    jp      z,plot_MODE3
    jp      plot_MODE4
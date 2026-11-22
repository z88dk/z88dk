;
;       Plot pixel at (x,y) coordinate.



    SECTION code_clib
    PUBLIC  w_plotpixel


    EXTERN  plot_MODE0
    EXTERN  plot_MODE6
    EXTERN  plot_MODE64
    EXTERN  plot_MODE128
    EXTERN  __zx_gfxmode
    defc    NEEDplot=1


w_plotpixel:
    ld      a, (__zx_gfxmode)
    cp      3
    jp      c, plot_MODE0
IF    FORzxn
    bit     6, a
    jp      nz, plot_MODE64
    bit     7, a
    jp      nz, plot_MODE128
ENDIF
    jp      plot_MODE6




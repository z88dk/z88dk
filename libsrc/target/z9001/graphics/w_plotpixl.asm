
    SECTION	code_clib
    PUBLIC	w_plotpixel

    EXTERN	plot_MODE0
    EXTERN	plot_MODE1

    EXTERN	__z9001_mode


w_plotpixel:
    ld      a,(__z9001_mode)
    cp      1
    jp      z,plot_MODE1
    and     a
    ret     nz
    jp      plot_MODE0

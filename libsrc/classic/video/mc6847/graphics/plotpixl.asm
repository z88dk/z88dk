
    SECTION code_driver
    PUBLIC  plotpixel

    EXTERN  plot_MODE0
    EXTERN  plot_MODE1
    EXTERN  plot_MODE2

    EXTERN  __mc6847_mode
    EXTERN  __tms9918_plotpixel

    INCLUDE "classic/video/mc6847/mc6847.inc"


plotpixel:
               ; ld	(__gfx_coords),hl
    ld      a, (__mc6847_mode)
IF FORspc1000
    cp      10
    jp      z,__tms9918_plotpixel
ENDIF
IF MC6847_HAS_HIRES
    cp      1
    jp      z, plot_MODE1
ENDIF
    cp      2
    jp      z, plot_MODE2
IF MC6847_HAS_TEXT_GFX
    and     a
    ret     nz
    jp      plot_MODE0
ELSE
    ret
ENDIF

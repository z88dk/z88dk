
    SECTION code_driver
    PUBLIC  plotpixel

    EXTERN  plot_MODE0
    EXTERN  plot_MODE1
    EXTERN  plot_MODE2

               ; EXTERN  __gfx_coords
    EXTERN  __mc6847_mode

    INCLUDE "video/mc6847/mc6847.inc"


plotpixel:
               ; ld	(__gfx_coords),hl
    ld      a, (__mc6847_mode)
IF MC6847_HAS_HIRES
    cp      MODE_HIRES
    jp      z, plot_MODE1
ENDIF
    cp      MODE_MULTICOLOUR
    jp      z, plot_MODE2
    and     a
    ret     nz
    jp      plot_MODE0

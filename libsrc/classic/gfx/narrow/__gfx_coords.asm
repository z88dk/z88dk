

    SECTION bss_graphics
    PUBLIC  __gfx_coords


__gfx_coords:
    defw    0

IF  __CPU_INTEL__|__CPU_GBZ80__

    PUBLIC  __plot_ADDR

__plot_ADDR:
    defw    0

ENDIF

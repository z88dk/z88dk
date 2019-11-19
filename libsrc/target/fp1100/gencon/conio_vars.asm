
    MODULE conio_vars

    SECTION data_clib

    PUBLIC  __fp1100_mode
    PUBLIC  __fp1100_lores_graphics
    PUBLIC  __fp1100_attr

__fp1100_mode:   defb     0

__fp1100_lores_graphics:
                 defw     0

__fp1100_attr:  defb    0x07
                defb    0x00

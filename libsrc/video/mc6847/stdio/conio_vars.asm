
    MODULE  conio_vars

    SECTION bss_clib

    PUBLIC  __mc6847_mode
    PUBLIC  __mc6847_modeval

__mc6847_mode:
    defb    0

__mc6847_modeval:   
    defb    0

    SECTION data_clib

    SECTION data_clib



    PUBLIC  __mc6847_MODE2_attr
__mc6847_MODE2_attr:
    defb    @11000000, @00000000

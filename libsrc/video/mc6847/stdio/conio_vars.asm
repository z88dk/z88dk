
    MODULE  conio_vars

    SECTION bss_clib

    PUBLIC  __mc6847_mode

__mc6847_mode:
    defb    0

    SECTION data_clib

    SECTION data_clib

__mc6847_attr:
    defb    32                          ;We use the external character generator
__ink_colour:
    defb    7


    PUBLIC  __mc6847_MODE2_attr
__mc6847_MODE2_attr:
    defb    @11000000, @00000000

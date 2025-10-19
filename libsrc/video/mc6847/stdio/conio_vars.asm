
    MODULE  conio_vars

    SECTION bss_clib

    PUBLIC  __mc6847_mode

__mc6847_mode:
    defb    0

IF FORmc1000 | FORpc6001
    PUBLIC  __mc6847_modeval

__mc6847_modeval:   
    defb    0
ENDIF


    SECTION data_clib

    PUBLIC  __mc6847_MODE2_attr
__mc6847_MODE2_attr:
    defb    @11000000, @00000000


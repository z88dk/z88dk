
        SECTION code_clib

        PUBLIC  xor_MODE0

.xor_MODE0
        ld      a,l
        cp      48
        ret     nc
        ld      a,h
        cp      64
        ret     nc

        defc    NEEDxor = 1
        INCLUDE "graphics/generic_console/pixel6.asm"

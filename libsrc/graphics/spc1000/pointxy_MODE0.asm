
        SECTION code_clib

        PUBLIC  pointxy_MODE0

.pointxy_MODE0
        ld      a,l
        cp      48
        ret     nc
        ld      a,h
        cp      64
        ret     nc

        defc    NEEDpoint = 1
        INCLUDE "graphics/generic_console/pixel6.asm"

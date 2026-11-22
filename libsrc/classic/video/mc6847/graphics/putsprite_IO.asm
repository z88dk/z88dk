
INCLUDE "classic/video/mc6847/mc6847.inc"

IFDEF MC6847_IOSPACE


    SECTION smc_clib
    PUBLIC  putsprite
    PUBLIC  _putsprite
    EXTERN  __generic_putsprite


    defc    putsprite = __generic_putsprite
    defc    _putsprite = putsprite


ENDIF


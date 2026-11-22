
    SECTION code_clib
    PUBLIC  putsprite

    EXTERN  __generic_putsprite
    EXTERN  putsprite_MODE1

    EXTERN  __gal_mode


putsprite:
_putsprite:
__putsprite:
    ld      a, (__gal_mode)
    cp      1
    jp      z, putsprite_MODE1
    and     a
    ret     nz
    jp      __generic_putsprite

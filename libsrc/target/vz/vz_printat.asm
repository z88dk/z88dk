; CALLER LINKAGE FOR FUNCTION POINTERS

    SECTION code_clib
    PUBLIC  vz_printat
    PUBLIC  _vz_printat
    EXTERN  asm_vz_printat

vz_printat:
_vz_printat:

    pop     af
    pop     bc
    pop     hl
    pop     de
    push    af

    jp      asm_vz_printat

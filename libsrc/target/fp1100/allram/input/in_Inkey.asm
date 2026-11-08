; uint in_Inkey(void): carry set and HL = 0 for no key, else NC and HL = the ASCII (the same keys as getk).

    SECTION code_clib
    PUBLIC  in_Inkey
    PUBLIC  _in_Inkey
    EXTERN  getk

in_Inkey:
_in_Inkey:
    call    getk
    ld      a, h
    or      l
    jr      z, none
    and     a
    ret
none:
    scf
    ret

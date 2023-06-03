
SECTION code_clib

PUBLIC getk
PUBLIC _getk

INCLUDE "target/agon/def/mos_api.inc"

getk:
_getk:
    push    ix
    MOSCALL(mos_sysvars)
    defb    $5b     ;LIL
    ld      a,(ix+sysvar_vkeydown)
    and     a
    jr      z,nokey
    defb    $5b     ;LIL
    ld      a,(ix+sysvar_keyascii)
nokey:
    ld      l,a
    ld      h,0
    pop     ix
    ret

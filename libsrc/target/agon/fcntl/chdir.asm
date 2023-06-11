

SECTION code_clib
PUBLIC chdir
PUBLIC _chdir
EXTERN  __agon_hl24

INCLUDE "target/agon/def/mos_api.inc"

chdir:
_chdir:
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    ix
    call    __agon_hl24
    MOSCALL(mos_cd)
    pop     ix
    ld      hl,0
    and     a
    ret     z
    dec     hl
    ret

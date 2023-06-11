SECTION code_clib
PUBLIC readbyte
PUBLIC _readbyte

INCLUDE "target/agon/def/mos_api.inc"

readbyte:
_readbyte:
    pop     hl
    pop     bc
    push    bc
    push    hl
    push    ix
    MOSCALL(mos_fgetc)
    pop     ix
    ld      hl,-1
    ret     c
    ld      l,a
    ld      h,0
    ret


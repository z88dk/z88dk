

SECTION code_clib

PUBLIC asm_sprite_update

INCLUDE "config_private.inc"


; Entry: hl = sprite
;         c = sprite number
asm_sprite_update:
    ld      a,c
    ld      bc, __IO_SPRITE_SLOT
    out     (c),a
    ld      bc, __IO_SPRITE_ATTRIBUTE
    outi
    outi
    outi
    outi
    outi
    ret



SECTION code_clib

PUBLIC sprite_unset_xmirror


; void sprite_unset_xmirror(struct sprite *spr);
sprite_unset_xmirror:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_unset_xmirror.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_unset_xmirror
defc   _sprite_unset_xmirror = sprite_unset_xmirror
ENDIF

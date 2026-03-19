
SECTION code_clib

PUBLIC sprite_unset_ymirror


; void sprite_unset_ymirror(struct sprite *spr);
sprite_unset_ymirror:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_unset_ymirror.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_unset_ymirror
defc   _sprite_unset_ymirror = sprite_unset_ymirror
ENDIF

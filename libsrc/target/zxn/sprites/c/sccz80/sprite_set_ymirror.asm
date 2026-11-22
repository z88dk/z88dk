
SECTION code_clib

PUBLIC sprite_set_ymirror


; void sprite_set_ymirror(struct sprite *spr);
sprite_set_ymirror:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_ymirror.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_ymirror
defc   _sprite_set_ymirror = sprite_set_ymirror
ENDIF

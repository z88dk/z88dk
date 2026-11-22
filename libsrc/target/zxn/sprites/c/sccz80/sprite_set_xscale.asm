
SECTION code_clib

PUBLIC sprite_set_xscale


; void sprite_set_xscale(struct sprite *spr, uint8_t scale);
sprite_set_xscale:
    pop     af
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    af
    ld      a,c
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_xscale.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_xscale
defc   _sprite_set_xscale = sprite_set_xscale
ENDIF

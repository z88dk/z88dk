
SECTION code_clib

PUBLIC sprite_set_yscale


; void sprite_set_yscale(struct sprite *spr, uint8_t scale);
sprite_set_yscale:
    pop     af
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    af
    ld      a,c
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_yscale.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_yscale
defc   _sprite_set_yscale = sprite_set_yscale
ENDIF

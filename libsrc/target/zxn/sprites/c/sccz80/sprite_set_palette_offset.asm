
SECTION code_clib

PUBLIC sprite_set_palette_offset


; void sprite_set_palette_offset(struct sprite *spr, uint8_t pal);
sprite_set_palette_offset:
    pop     af
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    af
    ld      a,c
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_palette_offset.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_palette_offset
defc   _sprite_set_palette_offset = sprite_set_palette_offset
ENDIF

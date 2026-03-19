
SECTION code_clib

PUBLIC sprite_set_pattern_number


; void sprite_set_pattern_number(struct sprite *spr, uint8_t pattern);
sprite_set_pattern_number:
    pop     af
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    af
    ld      a,c
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_pattern_number.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_pattern_number
defc   _sprite_set_pattern_number = sprite_set_pattern_number
ENDIF

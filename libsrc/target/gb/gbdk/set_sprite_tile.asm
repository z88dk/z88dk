
        MODULE  set_sprite_tile

        PUBLIC  set_sprite_tile
        PUBLIC  _set_sprite_tile

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ set_sprite_tile(uint8_t nb, uint8_t tile) __smallc NONBANKED;
set_sprite_tile:
_set_sprite_tile:
        PUSH    BC

        LD      HL,sp+6        ; Skip return address and registers
        LD      C,(HL)          ; C = nb
        DEC     HL
        DEC     HL
        LD      D,(HL)          ; D = tile

        CALL    set_sprite_tile_impl

        POP     BC
        RET

set_sprite_tile_impl:
        LD      HL,OAM+2      ; Calculate origin of sprite info

        SLA     C               ; Multiply C by 4
        SLA     C
        LD      B,0x00
        ADD     HL,BC

        LD      A,D             ; Set sprite number
        LD      (HL),A
        RET

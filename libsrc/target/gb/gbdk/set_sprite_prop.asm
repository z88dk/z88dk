
        MODULE  set_sprite_prop

        PUBLIC  set_sprite_prop
        PUBLIC  _set_sprite_prop

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ set_sprite_prop(uint8_t nb, uint8_t prop) __smallc NONBANKED;
set_sprite_prop:
_set_sprite_prop:
        PUSH    BC

        LD      HL,sp+6        ; Skip return address and registers
        LD      C,(HL)          ; C = nb
        DEC     HL
        DEC     HL
        LD      D,(HL)          ; D = prop

        CALL    set_sprite_prop_impl

        POP     BC
        RET

set_sprite_prop_impl:
        LD      HL,OAM+3      ; Calculate origin of sprite info

        SLA     C               ; Multiply C by 4
        SLA     C
        LD      B,0x00
        ADD     HL,BC

        LD      A,D             ; Set sprite number
        LD      (HL),A
        RET

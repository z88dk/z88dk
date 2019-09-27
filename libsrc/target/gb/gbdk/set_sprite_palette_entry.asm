;       .title  "CGB support"
;       .module CGB

        MODULE  set_sprite_palette_entry

        PUBLIC  set_sprite_palette_entry
        PUBLIC  _set_sprite_palette_entry

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ set_sprite_palette_entry(uint8_t palette, uint8_t entry, uint16_t rgb_data) __smallc;
set_sprite_palette_entry:        ; Banked
_set_sprite_palette_entry:        ; Banked
        PUSH    BC
        PUSH    DE

        LD      HL,sp+6		; Skip return address and registers
        LD      C,(HL)          ; BC = rgb_data
        INC     HL
        LD      B,(HL)
        INC     HL
        LD      D,(HL)          ; D = pal_entry
        INC     HL
        INC     HL
        LD      E,(HL)          ; E = first_palette

        LD      A,E             ; E = first_palette
        ADD     A               ; A *= 8
        ADD     A
        ADD     A
        ADD     D               ; A += 2 * pal_entry
        ADD     D
        LD      E,A             ; A = first BCPS data

loop:
        LDH     A,(STAT)
        AND     0x02
        JR      NZ,loop

        LD      A,E
        LDH     (OCPS),A
        LD      A,C
        LDH     (OCPD),A
        INC     E               ; next BCPS

        LD      A,E
        LDH     (OCPS),A
        LD      A,B
        LDH     (OCPD),A

        POP     DE
        POP     BC
        RET

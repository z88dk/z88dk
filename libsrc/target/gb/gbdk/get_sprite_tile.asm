
        MODULE  get_sprite_tile

        PUBLIC  get_sprite_tile
        PUBLIC  _get_sprite_tile

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; uint8_t __LIB__ get_sprite_tile(uint8_t nb)  NONBANKED;
get_sprite_tile:
_get_sprite_tile:
        PUSH    BC

        LD      HL,sp+4        ; Skip return address and registers
        LD      C,(HL)          ; C = nb

        CALL    get_tile

        POP     BC
        RET

        ;; Get tile of sprite number C
get_tile:
        LD      HL,OAM+2      ; Calculate origin of sprite info

        SLA     C               ; Multiply C by 4
        SLA     C
        LD      B,0x00
        ADD     HL,BC

        LD      A,(HL)          ; Get sprite number
        LD      E,A
	LD	L,A
	LD	H,0
        RET


        MODULE  get_sprite_prop

        PUBLIC  get_sprite_prop
        PUBLIC  _get_sprite_prop

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; uint8_t __LIB__ get_sprite_prop(uint8_t nb)  NONBANKED;
get_sprite_prop:
_get_sprite_prop:
        PUSH    BC

        LD      HL,sp+4        ; Skip return address and registers
        LD      C,(HL)          ; C = nb

        CALL    get_prop

        POP     BC
        RET

        ;; Get prop of sprite number C
get_prop:
        LD      HL,OAM+3      ; Calculate origin of sprite info

        SLA     C               ; Multiply C by 4
        SLA     C
        LD      B,0x00
        ADD     HL,BC

        LD      A,(HL)          ; Get sprite number
        LD      E,A
	LD	L,A
	LD	H,0
        RET

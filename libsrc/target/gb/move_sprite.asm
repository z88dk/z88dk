


        MODULE  move_sprite

        PUBLIC  move_sprite
        PUBLIC  _move_sprite

	PUBLIC	mv_sprite


        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ move_sprite(uint8_t nb, uint8_t x, uint8_t y) __smallc NONBANKED;
move_sprite:
_move_sprite:
        PUSH    BC

	ld	hl,sp+8
        LD      C,(HL)          ; C = nb
	ld	hl,sp+6
        LD      D,(HL)          ; D = x
	ld	hl,sp+4
        LD      E,(HL)          ; E = y

        CALL    mv_sprite

        POP     BC
        RET

mv_sprite:
        LD      HL,OAM        ; Calculate origin of sprite info
        SLA     C               ; Multiply C by 4
        SLA     C
        LD      B,0x00
        ADD     HL,BC

        LD      A,E             ; Set Y
        LD      (HL+),A

        LD      A,D             ; Set X
        LD      (HL+),A
        RET

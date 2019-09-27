


        MODULE  move_win

        PUBLIC  move_win
        PUBLIC  _move_win


        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ move_win(uint8_t x, uint8_t y) __smallc NONBANKED;
move_win:
_move_win:
	ld	hl,sp+4
        LD      A,(HL)
        LDH     (WX),A
	ld	hl,sp+2
        LD      A,(HL)
        LDH     (WY),A
        RET

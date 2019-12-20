


        MODULE  move_bkg

        PUBLIC  move_bkg
        PUBLIC  _move_bkg


        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ move_bkg(uint8_t x, uint8_t y) __smallc NONBANKED;
move_bkg:
_move_bkg:
        LD      HL,sp+4         ; Skip return address
        LD      A,(HL)
        LDH     (SCX),A
        LD      HL,sp+2         ; Skip return address
        LD      A,(HL)
        LDH     (SCY),A
        RET

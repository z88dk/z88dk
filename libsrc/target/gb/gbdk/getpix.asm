    SECTION code_driver

    PUBLIC  getpix
    PUBLIC  _getpix

    GLOBAL  asm_getpix

    INCLUDE "target/gb/def/gb_globals.def"


; uint8_t __LIB__ getpix(uint8_t x, uint8_t y) __smallc;
getpix:
_getpix:			; Banked
	PUSH    BC

	LD 	HL,sp+6
	LD	B,(HL)	; B = x
	ld	hl,sp+4
	LD	C,(HL)	; C = y

	CALL	asm_getpix

	POP	BC
	RET

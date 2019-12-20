    SECTION code_driver

    PUBLIC  line
    PUBLIC  _line

    GLOBAL  __mode
    GLOBAL  gmode
    GLOBAL  asm_line

    INCLUDE "target/gb/def/gb_globals.def"


; void __LIB__ line(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2) __smallc;
_line:				; Banked
line:				; Banked
	PUSH    BC

	LD      A,(__mode)
	CP      G_MODE
	CALL	NZ,gmode

	LD 	HL,sp+10		; Skip return address and registers
	LD	B,(HL)	; B = x1
	ld	hl,sp+8
	LD	C,(HL)	; C = y1
	ld	hl,sp+6
	LD	D,(HL)	; D = x2
	ld	hl,sp+4
	LD	E,(HL)	; E = y2

	CALL	asm_line

	POP     BC
	RET

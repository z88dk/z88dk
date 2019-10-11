    SECTION code_driver

    PUBLIC  circle
    PUBLIC  _circle

    GLOBAL  __mode
    GLOBAL  gmode
    GLOBAL  __fillstyle
    GLOBAL  asm_circle


    INCLUDE "target/gb/def/gb_globals.def"


; void __LIB__    circle(uint8_t x, uint8_t y, uint8_t radius, uint8_t __fillstyle) __smallc;
circle:
_circle:			; Banked
	PUSH    BC

	LD	A,(__mode)
	CP	G_MODE
	CALL	NZ,gmode

	ld	hl,sp+10
	LD	B,(HL)	; B = x
	ld	hl,sp+8
	LD	C,(HL)	; C = y
	ld	hl,sp+6
	LD	D,(HL)	; D = Radius
	ld	hl,sp+4
	LD	A,(HL)
	LD	(__fillstyle),A

	CALL	asm_circle

	POP	BC
	RET
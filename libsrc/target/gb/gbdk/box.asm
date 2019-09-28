    SECTION code_driver

    PUBLIC  box
    PUBLIC  _box

    GLOBAL  __tempx_s
    GLOBAL  __tempy_s
    GLOBAL  __mode
    GLOBAL  gmode
    GLOBAL  __fillstyle
    GLOBAL  asm_box


    INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ box(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2, uint8_t __fillstyle) __smallc;
box:
_box:				; Banked
	PUSH    BC

	LD      A,(__mode)
	CP      G_MODE
	CALL	NZ,gmode

	LD 	HL,sp+12        	; Skip return address and registers
	LD	A,(HL)	; B = x1
	LD	(__tempx_s),A
	ld	hl,sp+10
	LD	A,(HL)	; C = y1
	LD	(__tempy_s),A
	ld	hl,sp+8
	LD	A,(HL)	; D = x2
	LD	(__tempx_s+1),A
	ld	hl,sp+6
	LD	A,(HL)	; E = y2
	LD	(__tempy_s+1),A
	ld	hl,sp+4
	LD	A,(HL)
	LD	(__fillstyle),A
	CALL	asm_box
	POP	BC
	RET
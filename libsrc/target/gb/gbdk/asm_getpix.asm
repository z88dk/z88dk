    SECTION code_driver

    PUBLIC  asm_getpix

    GLOBAL  __fgcolour
    GLOBAL  __bgcolour
    GLOBAL  __draw_mode

    GLOBAL  y_table



    INCLUDE "target/gb/def/gb_globals.def"


	;; Get color of pixel at point (B,C) returns in A
asm_getpix:
	LD	HL,y_table
	LD	D,0x00
	LD	E,C
	ADD	HL,DE
	ADD	HL,DE
	LD	A,(HL+)
	LD	H,(HL)
	LD	L,A

	LD	A,B
	AND	0xf8
	LD	E,A
	ADD	HL,DE
	ADD	HL,DE

	LD	A,B

	AND     7
	ADD     0x10		; Table of bits is located at 0x0010
	LD      C,A
	LD      B,0x00
	LD      A,(BC)
	LD      C,A

gp:
	LDH	A,(STAT)
	BIT	1,A
	JR	NZ,gp

	LD	A,(HL+)
	LD	D,A
	LD	A,(HL+)
	LD	E,A
	LD	B,0
	LD	A,D
	AND	C
	JR	Z,npix
	SET	0,B
npix:	LD	A,E
	AND	C
	JR	Z,end
	SET	1,B
end:	LD	E,B
	RET

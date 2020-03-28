    SECTION code_driver

    PUBLIC  asm_plot
    PUBLIC  asm_drawing_wrbyte

    GLOBAL  __fgcolour
    GLOBAL  __bgcolour
    GLOBAL  __draw_mode

    GLOBAL  y_table



    INCLUDE "target/gb/def/gb_globals.def"


	;; Draw a point at (B,C) with mode and color D
asm_plot:
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
	LD      B,A
	CPL
	LD      C,A

    ;; Fall into

asm_drawing_wrbyte:
	if	0
	LD	A,(mod_col)	; Restore color and mode
	LD	D,A

	BIT	5,D
	JR	NZ,wrbyte_10
	BIT	6,D
	JR	NZ,wrbyte_20
	BIT	7,D
	JR	NZ,wrbyte_30
	else
	LD	A,(__fgcolour)
	LD	D,A
	LD	A,(__draw_mode)
	CP	M_OR
	JR	Z,wrbyte_10
	CP	M_XOR
	JR	Z,wrbyte_20
	CP	M_AND
	JR	Z,wrbyte_30	
	endif

	; Fall through to SOLID by default
wrbyte_1:
	;; Solid
	LD	E,B
	if	0
	BIT	2,D
	else
	BIT	0,D
	endif
	JR	NZ,wrbyte_2
	PUSH	BC
	LD	B,0x00
wrbyte_2:
	if	0
	BIT	3,D
	else
	BIT	1,D
	endif
	JR	NZ,wrbyte_3
	LD	E,0x00
wrbyte_3:
	LDH	A,(STAT)
	BIT	1,A
	JR	NZ,wrbyte_3

	LD	A,(HL)
	AND	C
	OR	B
	LD	(HL+),A

	LD	A,(HL)
	AND	C
	OR	E
	LD	(HL),A
	LD	A,B
	OR	A
	RET	NZ
	POP	BC
	RET

wrbyte_10:
	;; Or
	LD      C,B
	if	0
	BIT     2,D
	else
	BIT	0,D
	endif
	JR      NZ,wrbyte_11
	LD      B,0x00
wrbyte_11:
	if	0
	BIT     3,D
	else
	BIT	1,D
	endif
	JR      NZ,wrbyte_12
	LD      C,0x00
wrbyte_12:
	LDH     A,(STAT)
	BIT     1,A
	JR      NZ,wrbyte_12

	LD      A,(HL)
	OR      B
	LD      (HL+),A

	LD      A,(HL)
	OR      C
	LD      (HL),A
	RET

wrbyte_20:
	;; Xor
	LD      C,B
	if	0
	BIT     2,D
	else
	BIT	0,D
	endif
	JR      NZ,wrbyte_21
	LD      B,0x00
wrbyte_21:
	if	0
	BIT     3,D
	else
	BIT	1,D
	endif
	JR      NZ,wrbyte_22
	LD      C,0x00
wrbyte_22:
	LDH     A,(STAT)
	BIT     1,A
	JR      NZ,wrbyte_22

	LD      A,(HL)
	XOR     B
	LD      (HL+),A

	LD      A,(HL)
	XOR     C
	LD      (HL),A
	RET

wrbyte_30:
	;; And
	LD      B,C
	if	0
	BIT     2,D
	else
	BIT	0,D
	endif
	JR      Z,wrbyte_31
	LD      B,0xFF
wrbyte_31:
	if	0
	BIT     3,D
	else
	BIT	1,D
	endif
	JR      Z,wrbyte_32
	LD      C,0xFF
wrbyte_32:
	LDH     A,(STAT)
	BIT     1,A
	JR      NZ,wrbyte_32

	LD      A,(HL)
	AND     B
	LD      (HL+),A

	LD      A,(HL)
	AND     C
	LD      (HL),A
	RET
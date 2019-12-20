    SECTION code_driver

    PUBLIC  asm_line

    GLOBAL  __templ_d
    GLOBAL  y_table

    GLOBAL  asm_drawing_wrbyte


	;; Draw a line between (B,C) and (D,E)
asm_line:
	LD	A,C	;Calculate Delta Y
	SUB	E
	JR	NC,s1
	CPL
	INC	A
s1:	LD	(delta_y),A
	LD	H,A

	LD	A,B	;Calculate Delta X
	SUB	D
	JR	NC,s2
	CPL
	INC	A
s2:	LD	(delta_x),A

	SUB	H
	JP	C,y1

	;; Use Delta X

	LD	A,B
	SUB	D
	JP	NC,x2

	LD	A,C
	SUB	E
	JR	Z,x3
	LD	A,0x00
	JR	NC,x3
	LD	A,0xFF
	JR	x3

x2:
	LD	A,E
	SUB	C
	JR	Z,x2a
	LD	A,0x00
	JR	NC,x2a
	LD	A,0xFF

x2a:
	LD	B,D
	LD	C,E	;BC holds start X,Y
x3:
	LD	(l_inc),A	;Store Y increment
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

	LD	A,(delta_y)
	OR	A
	JP	Z,xonly

	;;	Got to do it the hard way.

	;	Calculate (2*deltay) -> dinc1

	PUSH	HL
	LD	H,0x00
	LD	L,A
	ADD	HL,HL
	LD	A,H
	LD	(dinc1),A
	LD	A,L
	LD	(dinc1+1),A

	;	Calculate (2*deltay)-deltax -> d


	LD	D,H
	LD	E,L
	LD	A,(delta_x)
	CPL
	LD	L,A
	LD	H,0xFF
	INC	HL
dx1:
	ADD	HL,DE
	LD	A,H
	LD	(__templ_d),A
	LD	A,L
	LD	(__templ_d+1),A

	;	Calculate (deltay-deltax)*2 -> dinc2

	LD	A,(delta_x)
	CPL
	LD	L,A
	LD	H,0xFF
	INC	HL
	LD	A,(delta_y)
	LD	D,0x00
	LD	E,A
	ADD	HL,DE
	ADD	HL,HL

	LD	A,H
	LD	(dinc2),A
	LD	A,L
	LD	(dinc2+1),A

	POP	HL

	if	0
	LD	A,(mod_col)
	LD	D,A
	endif
	
	LD	A,(delta_x)
	LD	E,A

	LD	A,B
	AND	7
	ADD	0x10	; Table of bits is located at 0x0010
	LD	C,A
	LD	B,0x00
	LD	A,(BC)	; Get start bit
	LD	B,A
	LD	C,A

xloop:
	RRC	C
	LD	A,(__templ_d)
	BIT	7,A
	JR	Z,ychg
	PUSH	DE
	BIT	7,C
	JR	Z,nbit
	LD	A,B
	CPL
	LD	C,A
	CALL	asm_drawing_wrbyte
	DEC	HL
	LD	C,0x80
	LD	B,C
nbit:
	LD	A,(__templ_d+1)
	LD	D,A
	LD	A,(dinc1+1)
	ADD	D
	LD	(__templ_d+1),A
	LD	A,(__templ_d)
	LD	D,A
	LD	A,(dinc1)
	ADC	D
	LD	(__templ_d),A
	POP	DE
	JR	nchg
ychg:
	PUSH	DE
	PUSH	BC
	LD	A,B
	CPL
	LD	C,A
	CALL	asm_drawing_wrbyte
	LD	A,(l_inc)
	OR	A
	JR	Z,ydown
	INC	HL
	LD	A,L
	AND	0x0F
	JR	NZ,bound
	LD	DE,0x0130
	ADD	HL,DE	;Correct screen address
	JR	bound
ydown:
	DEC	HL
	DEC	HL
	DEC	HL
	LD	A,L
	AND	0x0F
	XOR	0x0E
	JR	NZ,bound
	LD	DE,0xFED0
	ADD	HL,DE	;Correct screen address
bound:
	LD	A,(__templ_d+1)
	LD	D,A
	LD	A,(dinc2+1)
	ADD	D
	LD	(__templ_d+1),A
	LD	A,(__templ_d)
	LD	D,A
	LD	A,(dinc2)
	ADC	D
	LD	(__templ_d),A
	POP	BC
	LD	B,C
	POP	DE
nchg:
	BIT	7,C
	JR	Z,nadj
	PUSH	DE
	LD	DE,0x0010
	ADD	HL,DE	;Correct screen address
	POP	DE
	LD	B,C
nadj:
	LD	A,B
	OR	C
	LD	B,A
	DEC	E
	JP	NZ,xloop
	LD	A,B
	CPL
	LD	C,A
	JP	asm_drawing_wrbyte

xonly:
	;; Draw accelerated horizontal line
	if	0
	;; xxx needed?
	LD	A,(mod_col)	
	LD	D,A
	endif

	LD	A,(delta_x)
	LD	E,A
	INC	E

	LD	A,B	;check X
	AND	7	;just look at bottom 3 bits
	JR	Z,xonly_2
	PUSH	HL
	ADD	0x10	;Table of bits is located at 0x0010
	LD	L,A
	LD	H,0x00
	LD	C,(HL)
	POP	HL
	XOR	A	;Clear A
xonly_1:	RRCA		;Shift data right 1
	OR	C
	DEC	E
	JR	Z,xonly_3
	BIT	0,A
	JR	Z,xonly_1
	JR	xonly_3
xonly_2:
	LD	A,E
	DEC	A
	AND	0xF8
	JR	Z,xonly_4
	JR	xonly_8
xonly_3:
	LD	B,A
	CPL
	LD	C,A
	PUSH	DE
	CALL	asm_drawing_wrbyte
	LD	DE,0x0F
	ADD	HL,DE	;Correct screen address
	POP	DE

xonly_8:	LD	A,E
	OR	A
	RET	Z
	AND	0xF8
	JR	Z,xonly_4

	XOR	A
	LD	C,A
	CPL
	LD	B,A

	PUSH	DE
	CALL	asm_drawing_wrbyte
	LD	DE,0x0F
	ADD	HL,DE	;Correct screen address
	POP	DE
	LD	A,E
	SUB	8
	RET	Z
	LD	E,A
	JR	xonly_8

xonly_4:	LD	A,0x80
xonly_5:	DEC	E
	JR	Z,xonly_6
	SRA	A
	JR	xonly_5
xonly_6:	LD	B,A
	CPL
	LD	C,A
	JP	asm_drawing_wrbyte

	;; Use Delta Y
y1:
	LD	A,C
	SUB	E
	JP	NC,y2

	LD	A,B
	SUB	D
	JR	Z,y3
	LD	A,0x00
	JR	NC,y3
	LD	A,0xFF
	JR	y3

y2:
	LD	A,C
	SUB	E
	JR	Z,y2a
	LD	A,0x00
	JR	NC,y2a
	LD	A,0xFF

y2a:
	LD	B,D
	LD	C,E	;BC holds start X,Y

y3:
	LD	(l_inc),A	;Store X increment
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

	if	0
	;; Trashed by later instructions
	LD	A,(mod_col)
	LD	D,A
	endif
	
	LD	A,(delta_y)
	LD	E,A
	INC	E

	LD	A,(delta_x)
	OR	A
	JP	Z,yonly

	;;	Got to do it the hard way.

	;	Calculate (2*deltax) -> dinc1

	PUSH	HL
	LD	H,0x00
	LD	L,A
	ADD	HL,HL
	LD	A,H
	LD	(dinc1),A
	LD	A,L
	LD	(dinc1+1),A

	;	Calculate (2*deltax)-deltay -> d


	LD	D,H
	LD	E,L
	LD	A,(delta_y)
	CPL
	LD	L,A
	LD	H,0xFF
	INC	HL
dy1:
	ADD	HL,DE
	LD	A,H
	LD	(__templ_d),A
	LD	A,L
	LD	(__templ_d+1),A

	;	Calculate (deltax-deltay)*2 -> dinc2

	LD	A,(delta_y)
	CPL
	LD	L,A
	LD	H,0xFF
	INC	HL
	LD	A,(delta_x)
	LD	D,0x00
	LD	E,A
	ADD	HL,DE
	ADD	HL,HL

	LD	A,H
	LD	(dinc2),A
	LD	A,L
	LD	(dinc2+1),A

	POP	HL

	if	0
	;; xxx Not used?
	LD	A,(mod_col)
	LD	D,A
	endif

	LD	A,(delta_y)
	LD	E,A

	LD	A,B
	AND	7
	ADD	0x10	; Table of bits is located at 0x0010
	LD	C,A
	LD	B,0x00
	LD	A,(BC)	; Get start bit
	LD	B,A
	LD	C,A

yloop:
	PUSH	DE
	PUSH	BC
	LD	A,B
	CPL
	LD	C,A
	CALL	asm_drawing_wrbyte
	INC	HL
	LD	A,L
	AND	0x0F
	JR	NZ,nybound
	LD	DE,0x0130
	ADD	HL,DE	;Correct screen address
nybound:
	POP	BC
	LD	A,(__templ_d)
	BIT	7,A
	JR	Z,xchg
	LD	A,(__templ_d+1)
	LD	D,A
	LD	A,(dinc1+1)
	ADD	D
	LD	(__templ_d+1),A
	LD	A,(__templ_d)
	LD	D,A
	LD	A,(dinc1)
	ADC	D
	LD	(__templ_d),A
	JR	nchgy
xchg:
	LD	A,(l_inc)
	OR	A
	JR	NZ,yright
	RLC	B
	BIT	0,B
	JR	Z,boundy
	LD	DE,0xFFF0
	ADD	HL,DE	;Correct screen address
	JR	boundy
yright:
	RRC	B
	BIT	7,B
	JR	Z,boundy
	LD	DE,0x0010
	ADD	HL,DE	;Correct screen address
boundy:
	LD	A,(__templ_d+1)
	LD	D,A
	LD	A,(dinc2+1)
	ADD	D
	LD	(__templ_d+1),A
	LD	A,(__templ_d)
	LD	D,A
	LD	A,(dinc2)
	ADC	D
	LD	(__templ_d),A
nchgy:
	POP	DE
	DEC	E
	JR	NZ,yloop
	LD	A,B
	CPL
	LD	C,A
	JP	asm_drawing_wrbyte

yonly:
	;; Draw accelerated vertical line
	LD	A,B	;check X
	AND	7	;just look at bottom 3 bits
	PUSH	HL
	ADD	0x10	;Table of bits is located at 0x0010
	LD	L,A
	LD	H,0x00
	LD	A,(HL)	;Get mask bit
	POP	HL
	LD	B,A
	CPL
	LD	C,A

yonly_1:	PUSH	DE
	CALL	asm_drawing_wrbyte
	INC	HL	;Correct screen address
	LD	A,L
	AND	0x0F
	JR	NZ,yonly_2
	LD	DE,0x0130
	ADD	HL,DE
yonly_2:	POP	DE
	DEC	E
	RET	Z
	JR	yonly_1

	SECTION	bss_driver

dinc1:
        defs    2
dinc2:
        defs    2
l_inc:
        defs    1
delta_x:
        defs    1
delta_y:
        defs    1

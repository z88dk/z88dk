    SECTION code_driver

    PUBLIC  asm_box

    GLOBAL  __tempx_s
    GLOBAL  __tempy_s
    GLOBAL  __fillstyle
    GLOBAL  __fgcolour
    GLOBAL  __bgcolour
    GLOBAL  asm_line



	;; Draw a box between (B,C) and (D,E)
asm_box:
	LD	A,(__tempx_s)
	LD	B,A
	LD	A,(__tempx_s+1)
	LD	C,A
	SUB	B
	JR	NC,ychk
	LD	A,C
	LD	(__tempx_s),A
	LD	A,B
	LD	(__tempx_s+1),A
ychk:
	LD	A,(__tempy_s)
	LD	B,A
	LD	A,(__tempy_s+1)
	LD	C,A
	SUB	B
	JR	NC,dbox
	LD	A,C
	LD	(__tempy_s),A
	LD	A,B
	LD	(__tempy_s+1),A
dbox:
	LD	A,(__tempx_s)
	LD	B,A
	LD	D,A
	LD	A,(__tempy_s)
	LD	C,A
	LD	A,(__tempy_s+1)
	LD	E,A
	CALL	asm_line
	LD	A,(__tempx_s+1)
	LD	B,A
	LD	D,A
	LD	A,(__tempy_s)
	LD	C,A
	LD	A,(__tempy_s+1)
	LD	E,A
	CALL	asm_line
	LD	A,(__tempx_s)
	INC	A
	LD	(__tempx_s),A
	LD	A,(__tempx_s+1)
	DEC	A
	LD	(__tempx_s+1),A
	LD	A,(__tempx_s)
	LD	B,A
	LD	A,(__tempx_s+1)
	LD	D,A
	LD	A,(__tempy_s)
	LD	C,A
	LD	E,A
	CALL	asm_line
	LD	A,(__tempx_s)
	LD	B,A
	LD	A,(__tempx_s+1)
	LD	D,A
	LD	A,(__tempy_s+1)
	LD	C,A
	LD	E,A
	CALL	asm_line
	LD	A,(__fillstyle)
	OR	A
	RET	Z
	LD	A,(__tempx_s)
	LD	B,A
	LD	A,(__tempx_s+1)
	SUB	B
	RET	C
	LD	A,(__tempy_s)
	INC	A
	LD	(__tempy_s),A
	LD	A,(__tempy_s+1)
	DEC	A
	LD	(__tempy_s+1),A
	LD	A,(__tempy_s)
	LD	B,A
	LD	A,(__tempy_s+1)
	SUB	B
	RET	C

	if	0
	LD	A,(mod_col)	;Swap fore + back colours.
	LD	D,A
	AND	0xF0
	LD	C,A		;Preserve Style
	LD	A,D
	AND	0x0C
	RRCA
	RRCA
	OR	C		;Foreground->background + __fillstyle
	LD	C,A
	LD	A,D
	AND	0x03
	RLCA
	RLCA
	OR	C
	LD	(mod_col),A
	else
	LD	A,(__fgcolour)
	LD	C,A
	LD	A,(__bgcolour)
	LD	(__fgcolour),A
	LD	A,C
	LD	(__bgcolour),A
	endif 
filllp:
	LD	A,(__tempx_s)
	LD	B,A
	LD	A,(__tempx_s+1)
	LD	D,A
	LD	A,(__tempy_s)
	LD	C,A
	LD	E,A
	CALL	asm_line
	LD	A,(__tempy_s+1)
	LD	B,A
	LD	A,(__tempy_s)
	CP	B
	JR	Z,swap
	INC	A
	LD	(__tempy_s),A
	JR	filllp
swap:	
	if	0
	LD	A,(mod_col)	;Swap fore + back colours.
	LD	D,A
	AND	0xF0
	LD	C,A		;Preserve Style
	LD	A,D
	AND	0x0C
	RRCA
	RRCA
	OR	C		;Foreground->background + __fillstyle
	LD	C,A
	LD	A,D
	AND	0x03
	RLCA
	RLCA
	OR	C
	LD	(mod_col),A
	else
	LD	A,(__fgcolour)
	LD	C,A
	LD	A,(__bgcolour)
	LD	(__fgcolour),A
	LD	A,C
	LD	(__bgcolour),A
	endif
	RET
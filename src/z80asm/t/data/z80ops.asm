; TITLE	'Z80 Instruction Set in alphabetical order'
;
; $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/data/Attic/z80ops.asm,v 1.2 2011-07-09 17:36:09 pauloscustodio Exp $
; $Log: z80ops.asm,v $
; Revision 1.2  2011-07-09 17:36:09  pauloscustodio
; Copied cvs log into $Log$ history
;
; Revision 1.1  2011/07/09 01:06:38  pauloscustodio
; Started to build test suite in t/ *.t unsing Perl prove. Included test for all standard
; Z80 opcodes; need to be extended with directives and opcodes for Z80 variants.
;
;
; Adapted from z80pack-1.17.tgz http://www.autometer.de/unix4fun/z80pack/ftp/
; 
; Copyright (c) 1987-2008 Udo Munk
; 
; Permission is hereby granted, free of charge, to any person
; obtaining a copy of this software and associated documentation
; files (the "Software"), to deal in the Software without
; restriction, including without limitation the rights to use,
; copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the
; Software is furnished to do so, subject to the following
; conditions:
; 
; The above copyright notice and this permission notice shall be
; included in all copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
; OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
; OTHER DEALINGS IN THE SOFTWARE.

DEFC IND =	5
DEFC M   =	10H
DEFC N   =	20H
DEFC DIS =	30H

Z80OPS:
	ADC	A,(HL)
	ADC	A,(IX+IND)
	ADC	A,(IY+IND)
	ADC	A,A
	ADC	A,B
	ADC	A,C
	ADC	A,D
	ADC	A,E
	ADC	A,H
	ADC	A,L
	ADC	A,N
	ADC	HL,BC
	ADC	HL,DE
	ADC	HL,HL
	ADC	HL,SP
	ADD	A,(HL)
	ADD	A,(IX+IND)
	ADD	A,(IY+IND)
	ADD	A,A
	ADD	A,B
	ADD	A,C
	ADD	A,D
	ADD	A,E
	ADD	A,H
	ADD	A,L
	ADD	A,N
	ADD	HL,BC
	ADD	HL,DE
	ADD	HL,HL
	ADD	HL,SP
	ADD	IX,BC
	ADD	IX,DE
	ADD	IX,IX
	ADD	IX,SP
	ADD	IY,BC
	ADD	IY,DE
	ADD	IY,IY
	ADD	IY,SP
	AND	(HL)
	AND	(IX+IND)
	AND	(IY+IND)
	AND	A
	AND	B
	AND	C
	AND	D
	AND	E
	AND	H
	AND	L
	AND	N
	BIT	0,(HL)
	BIT	0,(IX+IND)
	BIT	0,(IY+IND)
	BIT	0,A
	BIT	0,B
	BIT	0,C
	BIT	0,D
	BIT	0,E
	BIT	0,H
	BIT	0,L
	BIT	1,(HL)
	BIT	1,(IX+IND)
	BIT	1,(IY+IND)
	BIT	1,A
	BIT	1,B
	BIT	1,C
	BIT	1,D
	BIT	1,E
	BIT	1,H
	BIT	1,L
	BIT	2,(HL)
	BIT	2,(IX+IND)
	BIT	2,(IY+IND)
	BIT	2,A
	BIT	2,B
	BIT	2,C
	BIT	2,D
	BIT	2,E
	BIT	2,H
	BIT	2,L
	BIT	3,(HL)
	BIT	3,(IX+IND)
	BIT	3,(IY+IND)
	BIT	3,A
	BIT	3,B
	BIT	3,C
	BIT	3,D
	BIT	3,E
	BIT	3,H
	BIT	3,L
	BIT	4,(HL)
	BIT	4,(IX+IND)
	BIT	4,(IY+IND)
	BIT	4,A
	BIT	4,B
	BIT	4,C
	BIT	4,D
	BIT	4,E
	BIT	4,H
	BIT	4,L
	BIT	5,(HL)
	BIT	5,(IX+IND)
	BIT	5,(IY+IND)
	BIT	5,A
	BIT	5,B
	BIT	5,C
	BIT	5,D
	BIT	5,E
	BIT	5,H
	BIT	5,L
	BIT	6,(HL)
	BIT	6,(IX+IND)
	BIT	6,(IY+IND)
	BIT	6,A
	BIT	6,B
	BIT	6,C
	BIT	6,D
	BIT	6,E
	BIT	6,H
	BIT	6,L
	BIT	7,(HL)
	BIT	7,(IX+IND)
	BIT	7,(IY+IND)
	BIT	7,A
	BIT	7,B
	BIT	7,C
	BIT	7,D
	BIT	7,E
	BIT	7,H
	BIT	7,L
	CALL	C,NN
	CALL	M,NN
	CALL	NC,NN
	CALL	NN
	CALL	NZ,NN
	CALL	P,NN
	CALL	PE,NN
	CALL	PO,NN
	CALL	Z,NN
	CCF
	CP	(HL)
	CP	(IX+IND)
	CP	(IY+IND)
	CP	A
	CP	B
	CP	C
	CP	D
	CP	E
	CP	H
	CP	L
	CP	N
	CPD
	CPDR
	CPI
	CPIR
	CPL
	DAA
	DEC	(HL)
	DEC	(IX+IND)
	DEC	(IY+IND)
	DEC	A
	DEC	B
	DEC	BC
	DEC	C
	DEC	D
	DEC	DE
	DEC	E
	DEC	H
	DEC	HL
	DEC	IX
	DEC	IY
	DEC	L
	DEC	SP
	DI
	DJNZ	ASMPC+DIS
	EI
	EX	(SP),HL
	EX	(SP),IX
	EX	(SP),IY
	EX	AF,AF'
	EX	DE,HL
	EXX
	HALT
	IM	0
	IM	1
	IM	2
	IN	A,(C)
	IN	A,(N)
	IN	B,(C)
	IN	C,(C)
	IN	D,(C)
	IN	E,(C)
	IN	H,(C)
	IN	L,(C)
	INC	(HL)
	INC	(IX+IND)
	INC	(IY+IND)
	INC	A
	INC	B
	INC	BC
	INC	C
	INC	D
	INC	DE
	INC	E
	INC	H
	INC	HL
	INC	IX
	INC	IY
	INC	L
	INC	SP
	IND
	INDR
	INI
	INIR
	JP	(HL)
	JP	(IX)
	JP	(IY)
	JP	C,NN
	JP	M,NN
	JP	NC,NN
	JP	NN
	JP	NZ,NN
	JP	P,NN
	JP	PE,NN
	JP	PO,NN
	JP	Z,NN
	JR	C,ASMPC+DIS
	JR	ASMPC+DIS
	JR	NC,ASMPC+DIS
	JR	NZ,ASMPC+DIS
	JR	Z,ASMPC+DIS
	LD	(BC),A
	LD	(DE),A
	LD	(HL),A
	LD	(HL),B
	LD	(HL),C
	LD	(HL),D
	LD	(HL),E
	LD	(HL),H
	LD	(HL),L
	LD	(HL),N
	LD	(IX+IND),A
	LD	(IX+IND),B
	LD	(IX+IND),C
	LD	(IX+IND),D
	LD	(IX+IND),E
	LD	(IX+IND),H
	LD	(IX+IND),L
	LD	(IX+IND),N
	LD	(IY+IND),A
	LD	(IY+IND),B
	LD	(IY+IND),C
	LD	(IY+IND),D
	LD	(IY+IND),E
	LD	(IY+IND),H
	LD	(IY+IND),L
	LD	(IY+IND),N
	LD	(NN),A
	LD	(NN),BC
	LD	(NN),DE
	LD	(NN),HL
	LD	(NN),IX
	LD	(NN),IY
	LD	(NN),SP
	LD	A,(BC)
	LD	A,(DE)
	LD	A,(HL)
	LD	A,(IX+IND)
	LD	A,(IY+IND)
	LD	A,(NN)
	LD	A,A
	LD	A,B
	LD	A,C
	LD	A,D
	LD	A,E
	LD	A,H
	LD	A,I
	LD	A,L
	LD	A,N
	LD	B,(HL)
	LD	B,(IX+IND)
	LD	B,(IY+IND)
	LD	B,A
	LD	B,B
	LD	B,C
	LD	B,D
	LD	B,E
	LD	B,H
	LD	B,L
	LD	B,N
	LD	BC,(NN)
	LD	BC,NN
	LD	C,(HL)
	LD	C,(IX+IND)
	LD	C,(IY+IND)
	LD	C,A
	LD	C,B
	LD	C,C
	LD	C,D
	LD	C,E
	LD	C,H
	LD	C,L
	LD	C,N
	LD	D,(HL)
	LD	D,(IX+IND)
	LD	D,(IY+IND)
	LD	D,A
	LD	D,B
	LD	D,C
	LD	D,D
	LD	D,E
	LD	D,H
	LD	D,L
	LD	D,N
	LD	DE,(NN)
	LD	DE,NN
	LD	E,(HL)
	LD	E,(IX+IND)
	LD	E,(IY+IND)
	LD	E,A
	LD	E,B
	LD	E,C
	LD	E,D
	LD	E,E
	LD	E,H
	LD	E,L
	LD	E,N
	LD	H,(HL)
	LD	H,(IX+IND)
	LD	H,(IY+IND)
	LD	H,A
	LD	H,B
	LD	H,C
	LD	H,D
	LD	H,E
	LD	H,H
	LD	H,L
	LD	H,N
	LD	HL,(NN)
	LD	HL,NN
	LD	I,A
	LD	IX,(NN)
	LD	IX,NN
	LD	IY,(NN)
	LD	IY,NN
	LD	L,(HL)
	LD	L,(IX+IND)
	LD	L,(IY+IND)
	LD	L,A
	LD	L,B
	LD	L,C
	LD	L,D
	LD	L,E
	LD	L,H
	LD	L,L
	LD	L,N
	LD	SP,(NN)
	LD	SP,HL
	LD	SP,IX
	LD	SP,IY
	LD	SP,NN
	LDD
	LDDR
	LDI
	LDIR
	NEG
	NOP
	OR	(HL)
	OR	(IX+IND)
	OR	(IY+IND)
	OR	A
	OR	B
	OR	C
	OR	D
	OR	E
	OR	H
	OR	L
	OR	N
	OTDR
	OTIR
	OUT	(C),A
	OUT	(C),B
	OUT	(C),C
	OUT	(C),D
	OUT	(C),E
	OUT	(C),H
	OUT	(C),L
	OUT	(N),A
	OUTD
	OUTI
	POP	AF
	POP	BC
	POP	DE
	POP	HL
	POP	IX
	POP	IY
	PUSH	AF
	PUSH	BC
	PUSH	DE
	PUSH	HL
	PUSH	IX
	PUSH	IY
	RES	0,(HL)
	RES	0,(IX+IND)
	RES	0,(IY+IND)
	RES	0,A
	RES	0,B
	RES	0,C
	RES	0,D
	RES	0,E
	RES	0,H
	RES	0,L
	RES	1,(HL)
	RES	1,(IX+IND)
	RES	1,(IY+IND)
	RES	1,A
	RES	1,B
	RES	1,C
	RES	1,D
	RES	1,E
	RES	1,H
	RES	1,L
	RES	2,(HL)
	RES	2,(IX+IND)
	RES	2,(IY+IND)
	RES	2,A
	RES	2,B
	RES	2,C
	RES	2,D
	RES	2,E
	RES	2,H
	RES	2,L
	RES	3,(HL)
	RES	3,(IX+IND)
	RES	3,(IY+IND)
	RES	3,A
	RES	3,B
	RES	3,C
	RES	3,D
	RES	3,E
	RES	3,H
	RES	3,L
	RES	4,(HL)
	RES	4,(IX+IND)
	RES	4,(IY+IND)
	RES	4,A
	RES	4,B
	RES	4,C
	RES	4,D
	RES	4,E
	RES	4,H
	RES	4,L
	RES	5,(HL)
	RES	5,(IX+IND)
	RES	5,(IY+IND)
	RES	5,A
	RES	5,B
	RES	5,C
	RES	5,D
	RES	5,E
	RES	5,H
	RES	5,L
	RES	6,(HL)
	RES	6,(IX+IND)
	RES	6,(IY+IND)
	RES	6,A
	RES	6,B
	RES	6,C
	RES	6,D
	RES	6,E
	RES	6,H
	RES	6,L
	RES	7,(HL)
	RES	7,(IX+IND)
	RES	7,(IY+IND)
	RES	7,A
	RES	7,B
	RES	7,C
	RES	7,D
	RES	7,E
	RES	7,H
	RES	7,L
	RET
	RET	C
	RET	M
	RET	NC
	RET	NZ
	RET	P
	RET	PE
	RET	PO
	RET	Z
	RETI
	RETN
	RL	(HL)
	RL	(IX+IND)
	RL	(IY+IND)
	RL	A
	RL	B
	RL	C
	RL	D
	RL	E
	RL	H
	RL	L
	RLA
	RLC	(HL)
	RLC	(IX+IND)
	RLC	(IY+IND)
	RLC	A
	RLC	B
	RLC	C
	RLC	D
	RLC	E
	RLC	H
	RLC	L
	RLCA
	RLD
	RR	(HL)
	RR	(IX+IND)
	RR	(IY+IND)
	RR	A
	RR	B
	RR	C
	RR	D
	RR	E
	RR	H
	RR	L
	RRA
	RRC	(HL)
	RRC	(IX+IND)
	RRC	(IY+IND)
	RRC	A
	RRC	B
	RRC	C
	RRC	D
	RRC	E
	RRC	H
	RRC	L
	RRCA
	RRD
	RST	0
	RST	10H
	RST	18H
	RST	20H
	RST	28H
	RST	30H
	RST	38H
	RST	8
	SBC	A,(HL)
	SBC	A,(IX+IND)
	SBC	A,(IY+IND)
	SBC	A,A
	SBC	A,B
	SBC	A,C
	SBC	A,D
	SBC	A,E
	SBC	A,H
	SBC	A,L
	SBC	A,N
	SBC	HL,BC
	SBC	HL,DE
	SBC	HL,HL
	SBC	HL,SP
	SCF
	SET	0,(HL)
	SET	0,(IX+IND)
	SET	0,(IY+IND)
	SET	0,A
	SET	0,B
	SET	0,C
	SET	0,D
	SET	0,E
	SET	0,H
	SET	0,L
	SET	1,(HL)
	SET	1,(IX+IND)
	SET	1,(IY+IND)
	SET	1,A
	SET	1,B
	SET	1,C
	SET	1,D
	SET	1,E
	SET	1,H
	SET	1,L
	SET	2,(HL)
	SET	2,(IX+IND)
	SET	2,(IY+IND)
	SET	2,A
	SET	2,B
	SET	2,C
	SET	2,D
	SET	2,E
	SET	2,H
	SET	2,L
	SET	3,(HL)
	SET	3,(IX+IND)
	SET	3,(IY+IND)
	SET	3,A
	SET	3,B
	SET	3,C
	SET	3,D
	SET	3,E
	SET	3,H
	SET	3,L
	SET	4,(HL)
	SET	4,(IX+IND)
	SET	4,(IY+IND)
	SET	4,A
	SET	4,B
	SET	4,C
	SET	4,D
	SET	4,E
	SET	4,H
	SET	4,L
	SET	5,(HL)
	SET	5,(IX+IND)
	SET	5,(IY+IND)
	SET	5,A
	SET	5,B
	SET	5,C
	SET	5,D
	SET	5,E
	SET	5,H
	SET	5,L
	SET	6,(HL)
	SET	6,(IX+IND)
	SET	6,(IY+IND)
	SET	6,A
	SET	6,B
	SET	6,C
	SET	6,D
	SET	6,E
	SET	6,H
	SET	6,L
	SET	7,(HL)
	SET	7,(IX+IND)
	SET	7,(IY+IND)
	SET	7,A
	SET	7,B
	SET	7,C
	SET	7,D
	SET	7,E
	SET	7,H
	SET	7,L
	SLA	(HL)
	SLA	(IX+IND)
	SLA	(IY+IND)
	SLA	A
	SLA	B
	SLA	C
	SLA	D
	SLA	E
	SLA	H
	SLA	L
	SRA	(HL)
	SRA	(IX+IND)
	SRA	(IY+IND)
	SRA	A
	SRA	B
	SRA	C
	SRA	D
	SRA	E
	SRA	H
	SRA	L
	SRL	(HL)
	SRL	(IX+IND)
	SRL	(IY+IND)
	SRL	A
	SRL	B
	SRL	C
	SRL	D
	SRL	E
	SRL	H
	SRL	L
	SUB	(HL)
	SUB	(IX+IND)
	SUB	(IY+IND)
	SUB	A
	SUB	B
	SUB	C
	SUB	D
	SUB	E
	SUB	H
	SUB	L
	SUB	N
	XOR	(HL)
	XOR	(IX+IND)
	XOR	(IY+IND)
	XOR	A
	XOR	B
	XOR	C
	XOR	D
	XOR	E
	XOR	H
	XOR	L
	XOR	N

NN:	DEFS	2


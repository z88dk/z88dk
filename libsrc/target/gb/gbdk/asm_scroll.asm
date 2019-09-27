; font.ms
;
;	Michael Hope, 1999
;	michaelh@earthling.net
;	Distrubuted under the Artistic License - see www.opensource.org
;


	SECTION	code_driver

	PUBLIC	asm_scroll

        INCLUDE "target/gb/def/gb_globals.def"

	;; Scroll the whole screen
asm_scroll:
	PUSH	BC
	PUSH	DE
	PUSH	HL
	LD	HL,0x9800
	LD	BC,0x9800+0x20 ; BC = next line
	LD	E,0x20-0x01	; E = height - 1
scroll_1:
	LD	D,0x20		; D = width
scroll_2:
	LDH	A,(STAT)
	AND	0x02
	JR	NZ,scroll_2

	LD	A,(BC)
	LD	(HL+),A
	INC	BC
	DEC	D
	JR	NZ,scroll_2
	DEC	E
	JR	NZ,scroll_1

	LD	D,0x20
scroll_3:
	LDH	A,(STAT)
	AND	0x02
	JR	NZ,scroll_3

	LD	A,' '
	LD	(HL+),A
	DEC	D
	JR	NZ,scroll_3
	POP	HL
	POP	DE
	POP	BC
	RET

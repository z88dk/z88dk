

        MODULE  set_xy_t

        PUBLIC  set_xy_wtt
        PUBLIC  set_xy_btt
        PUBLIC  set_xy_tt


        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"


	;; Set window tile table from BC at XY = DE of size WH = HL
	;; wh >= (1,1)
set_xy_wtt:
	PUSH	HL		; Store WH
	LDH	A,(LCDC)
	BIT	6,A
	jr	nz,set_xy_wtt_1
	LD	HL,0x9800	; HL = origin
	JR	set_xy_tt
set_xy_wtt_1:
	LD	HL,0x9C00	; HL = origin
	JR	set_xy_tt


	;; Set background tile table from (BC) at XY = DE of size WH = HL
	;; WH >= (1,1)
set_xy_btt:
	PUSH	HL		; Store WH
	LDH	A,(LCDC)
	BIT	3,A
	jr	nz,set_xy_btt_1
	LD	HL,0x9800	; HL = origin
	JR	set_xy_tt
set_xy_btt_1:
	LD	HL,0x9C00	; HL = origin
;	JR	set_xy_tt

set_xy_tt:
	PUSH	BC		; Store source
	XOR	A
	OR	E
	JR	Z,set_xy_tt_2

	LD	BC,0x20	; One line is 20 tiles
set_xy_tt_1:
	ADD	HL,BC		; Y coordinate
	DEC	E
	JR	NZ,set_xy_tt_1
set_xy_tt_2:
	LD	B,0x00		; X coordinate
	LD	C,D
	ADD	HL,BC

	POP	BC		; BC = source
	POP	DE		; DE = WH
	PUSH	HL		; Store origin
	PUSH	DE		; Store WH
set_xy_tt_3:
	LDH	A,(STAT)
	AND	0x02
	JR	NZ,set_xy_tt_3

	LD	A,(BC)		; Copy W tiles
	LD	(HL+),A
	INC	BC
	DEC	D
	JR	NZ,set_xy_tt_3
	POP	HL		; HL = WH
	LD	D,H		; Restore D = W
	POP	HL		; HL = origin
	DEC	E
	RET	z

	PUSH	BC		; Next line
	LD	BC,0x20	; One line is 20 tiles
	ADD	HL,BC
	POP	BC

	PUSH	HL		; Store current origin
	PUSH	DE		; Store WH
	JR	set_xy_tt_3



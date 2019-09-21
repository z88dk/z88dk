


        MODULE  get_data

	PUBLIC	get_bkg_data
	PUBLIC	_get_bkg_data
	PUBLIC	get_win_data
	PUBLIC	_get_win_data
	PUBLIC	get_sprite_data
	PUBLIC	_get_sprite_data

	GLOBAL	copy_vram

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"


; void __LIB__ set_bkg_data(uint8_t first_tile, uint8_t nb_tiles, unsigned char *data) __smallc NONBANKED;
; void __LIB__ set_win_data(uint8_t first_tile, uint8_t nb_tiles, unsigned char *data) __smallc NONBANKED;
get_bkg_data:
_get_bkg_data:
get_win_data:
_get_win_data:
	LDH	A,(LCDC)
	BIT	4,A
	JP	NZ,_get_sprite_data

	PUSH	BC

	ld	hl,sp+4
	LD	C,(HL)		; BC = data
	INC	HL
	LD	B,(HL)
	INC	HL
	LD	E,(HL)		; E = nb_tiles
	INC	HL
	INC	HL
	LD	L,(HL)		; L = first_tile
	PUSH	HL

	XOR	A
	OR	E		; Is nb_tiles == 0?
	JR	NZ,set_1
	LD	DE,0x1000	; DE = nb_tiles = 256
	JR	set_2
set_1:
	LD	H,0x00		; HL = nb_tiles
	LD	L,E
	ADD	HL,HL		; HL *= 16
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL
	LD	D,H		; DE = nb_tiles
	LD	E,L
set_2:
	POP	HL		; HL = first_tile
	LD	A,L
	RLCA			; Sign extend (patterns have signed numbers)
	SBC	A
	LD	H,A
	ADD	HL,HL		; HL *= 16
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL

	PUSH	BC
	LD	BC,0x9000
	ADD	HL,BC
	POP	BC

set_3:			; Special version of '.copy_vram'
	BIT	3,H		; Bigger than 0x9800
	JR	Z,set_4
	BIT	4,H
	JR	Z,set_4
	RES	4,H		; Switch to 0x8800
set_4:
	LDH	A,(STAT)
	AND	0x02
	JR	NZ,set_4

	LD	A,(HL+)
	LD	(BC),A
	INC	BC
	DEC	DE
	LD	A,D
	OR	E
	JR	NZ,set_3

	POP	BC
	RET

get_sprite_data:
_get_sprite_data:
	PUSH	BC
	
	ld	hl,sp+4
	LD	C,(HL)		; BC = data
	INC	HL
	LD	B,(HL)
	INC	HL
	LD	E,(HL)		; E = nb_tiles
	INC	HL
	INC	HL
	LD	L,(HL)		; L = first_tile
	PUSH	HL

	XOR	A
	OR	E		; Is nb_tiles == 0?
	JR	NZ,spr_1
	LD	DE,0x1000	; DE = nb_tiles = 256
	JR	spr_2
spr_1:
	LD	H,0x00		; HL = nb_tiles
	LD	L,E
	ADD	HL,HL		; HL *= 16
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL
	LD	D,H		; DE = nb_tiles
	LD	E,L
spr_2:
	POP	HL		; HL = first_tile
	LD	L,A
	ADD	HL,HL		; HL *= 16
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL

	PUSH	BC
	LD	BC,0x8000
	ADD	HL,BC
	LD	B,H
	LD	C,L
	POP	HL

	CALL	copy_vram

	POP	BC
	RET

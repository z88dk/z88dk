
        MODULE  get_set_data

        PUBLIC  get_data
        PUBLIC  _get_data
        PUBLIC  set_data
        PUBLIC  _set_data
	GLOBAL	copy_vram

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"


;void __LIB__ set_data(unsigned char *vram_addr, unsigned char *data, uint16_t len) __smallc NONBANKED;
;void __LIB__ get_data(unsigned char *data, unsigned char *vram_addr, uint16_t len) __smallc NONBANKED;
_set_data:
set_data:
_get_data:
get_data:
	PUSH	BC
	LD 	HL,sp+4 	; Skip return address and registers
	LD	e,(HL)		; DE = len
	INC	HL
	LD	d,(HL)
	INC	HL
	LD	c,(HL)		; BC = src
	INC	HL
	LD	b,(HL)
	INC	HL
	LD	A,(HL+)		; HL = dst
	LD	H,(HL)
	LD	L,A

	CALL	copy_vram

	POP	BC
	RET

	;; Copy part (size = DE) of the VRAM from (BC) to (HL)
copy_vram:
	LDH	A,(STAT)
	AND	0x02
	JR	NZ,copy_vram

	LD	A,(BC)
	LD	(HL+),A
	INC	BC
	DEC	DE
	LD	A,D
	OR	E
	JR	NZ,copy_vram
	RET


    SECTION code_driver

    PUBLIC  plot_point
    PUBLIC  _plot_point

    GLOBAL  __mode
    GLOBAL  gmode
    GLOBAL  asm_plot

    INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ plot_point(uint8_t x, uint8_t y) __smallc;
_plot_point:			; Banked
plot_point:			; Banked
	PUSH    BC

	LD	A,(__mode)
	CP	G_MODE
	CALL	NZ,gmode

	LD 	HL,sp+6		; Skip return address and registers
	LD	B,(HL)	; B = x
	ld	hl,sp+4
	LD	C,(HL)	; C = y

	CALL	asm_plot

	POP	BC
	RET
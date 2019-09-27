    SECTION code_driver

    PUBLIC  plot
    PUBLIC  _plot

    GLOBAL  __mode
    GLOBAL  gmode
    GLOBAL  __fgcolour
    GLOBAL  __bgcolour
    GLOBAL  __draw_mode
    GLOBAL  asm_plot

    INCLUDE "target/gb/def/gb_globals.def"

	;; Old, compatible version of plot()
;void __LIB__ plot(uint8_t x, uint8_t y, uint8_t colour, uint8_t mode) __smallc;
	PUBLIC	plot
	PUBLIC	_plot
plot:
_plot:				; Banked
	PUSH    BC

	LD	A,(__mode)
	CP	G_MODE
	CALL	NZ,gmode

	LD 	HL,sp+10	; Skip return address and registers
	LD	B,(HL)		; B = x
	ld	hl,sp+8
	LD	C,(HL)		; C = y
	ld	hl,sp+6
	LD	A,(HL)		; colour
	LD	(__fgcolour),A
	ld	hl,sp+4
	LD	A,(HL)		; mode
	LD	(__draw_mode),A
	
	CALL	asm_plot

	POP	BC
	RET
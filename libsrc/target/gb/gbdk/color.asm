
    SECTION code_driver

    PUBLIC  color
    PUBLIC  _color

    GLOBAL  __fgcolour
    GLOBAL  __bgcolour
    GLOBAL  __draw_mode


    INCLUDE "target/gb/def/gb_globals.def"


;void __LIB__ color(uint8_t forecolor, uint8_t backcolor, uint8_t mode) __smallc;
color:
_color:			; Banked
	ld	hl,sp+6
	LD	A,(HL)	; A = Foreground
	LD	(__fgcolour),a
	ld	hl,sp+4
	LD	A,(HL)
	LD	(__bgcolour),a
	ld	hl,sp+2
	LD	A,(HL)
	LD	(__draw_mode),a
	RET


	SECTION	code_driver

	PUBLIC	draw_image
	PUBLIC	_draw_image

	GLOBAL	__mode
	GLOBAL	gmode
	GLOBAL	asm_draw_image

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ draw_image(unsigned char *data) NONBANKED;
draw_image:                     ; Non banked as pointer
_draw_image:                    ; Non banked as pointer
        PUSH    BC

        LD      A,(__mode)
        CP      G_MODE
        CALL    NZ,gmode

        LD      HL,sp+4         ; Skip return address and registers
        LD      A,(HL+) ; HL = data
        LD      C,A
        LD      B,(HL)

        CALL    asm_draw_image

        POP     BC
        RET

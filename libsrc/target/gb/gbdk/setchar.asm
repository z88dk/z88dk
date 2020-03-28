


        MODULE  setchar

        PUBLIC  setchar
        PUBLIC  _setchar

	EXTERN	asm_setchar
	EXTERN	__console_x

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

setchar:
_setchar:                       ; Banked
        PUSH    BC
        LD      HL,sp + 4  ; Skip return address
        LD      A,(HL)          ; A = c
	ld	hl,__console_x
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
        CALL    asm_setchar
        POP     BC
        RET

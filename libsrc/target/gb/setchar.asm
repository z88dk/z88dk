


        MODULE  setchar

        PUBLIC  setchar
        PUBLIC  _setchar

	EXTERN	asm_setchar

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

setchar:
_setchar:                       ; Banked
        PUSH    BC
        LD      HL,sp + 4  ; Skip return address
        LD      A,(HL)          ; A = c
        CALL    asm_setchar
        POP     BC
        RET

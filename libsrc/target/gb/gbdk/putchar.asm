


        MODULE  putchar

        PUBLIC  putchar
        PUBLIC  _putchar

	EXTERN	asm_putchar

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

putchar:
_putchar:                       ; Banked
        PUSH    BC
        LD      HL,sp + 4  ; Skip return address
        LD      A,(HL)          ; A = c
        CALL    asm_putchar
        POP     BC
        RET

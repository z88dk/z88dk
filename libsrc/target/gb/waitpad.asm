


        MODULE  waitpad

        PUBLIC  waitpad
        PUBLIC  _waitpad


	GLOBAL	asm_jpad

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

;uint8_t __LIB__ waitpad(uint8_t mask) NONBANKED;
waitpad:
_waitpad:
        PUSH    BC
        LD      HL,sp+4         ; Skip return address and registers
        LD      B,(HL)
        CALL    wait_pad
        LD      E,A             ; Return result in DE
	ld	l,a
	ld	h,0
        POP     BC
        RET

wait_pad:
        CALL    asm_jpad           ; Read pad
        AND     B               ; Compare with mask?
        JR      Z,wait_pad            ; Loop if no intersection
        RET

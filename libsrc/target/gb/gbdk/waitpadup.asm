


        MODULE  waitpadup

        PUBLIC  waitpadup
        PUBLIC  _waitpadup

	GLOBAL	asm_jpad

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ waitpadup(void) NONBANKED;
waitpadup:
_waitpadup:
        PUSH    AF              ; Save modified registers
        PUSH    BC
wait_1:
        LD      B,0xFF
wait_2:
        CALL    asm_jpad
        OR      A               ; Have all buttons been released?
        JR      NZ,wait_1       ; Not yet

        DEC     B
        JR      NZ,wait_2
        POP     BC              ; Restore registers
        POP     AF
        RET

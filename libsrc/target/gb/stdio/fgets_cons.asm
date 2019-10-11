
        SECTION	code_driver

        PUBLIC	fgets_cons
        PUBLIC	_fgets_cons

        GLOBAL	__mode
        GLOBAL	tmode_inout
        GLOBAL	asm_getstring

        INCLUDE "target/gb/def/gb_globals.def"

; char *fgets_cons(char *str, size_t max)
fgets_cons:
_fgets_cons:
        LD      A,(__mode)
        CP      T_MODE_INOUT
        JR      Z,gets_1
        PUSH    BC
        CALL    tmode_inout
        POP     BC
gets_1:
        LD      HL,sp+4         ;Removed banking
        LD      A,(HL+)
        LD      H,(HL)          ; HL = s
        LD      L,A
        PUSH    HL
        CALL    asm_getstring
        POP     DE
        ld      h,d
        ld      l,e
        RET

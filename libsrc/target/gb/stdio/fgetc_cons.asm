
        SECTION	code_driver

        PUBLIC	fgetc_cons
        PUBLIC	_fgetc_cons

        GLOBAL	__mode	
        GLOBAL	tmode_inout
        GLOBAL	asm_getchar

        INCLUDE "target/gb/def/gb_globals.def"

fgetc_cons:
_fgetc_cons:
        LD      A,(__mode)
        CP      T_MODE_INOUT
        JR      Z,getchar_1
        PUSH    BC
        CALL    tmode_inout
        POP     BC
getchar_1:
        CALL    asm_getchar
        LD      E,A
        ld      d,0
        ld      l,a
        ld      h,d
        RET

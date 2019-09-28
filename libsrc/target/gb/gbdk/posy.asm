


        MODULE  posy
        SECTION code_driver

        PUBLIC  posy
        PUBLIC  _posy

	EXTERN	__mode
	EXTERN	__console_y
	EXTERN	tmode


        INCLUDE "target/gb/def/gb_globals.def"

; int8_t posy(void);
posy:
_posy:                          ; Banked
        LD      A,(__mode)
        AND     T_MODE
        JR      NZ,posy_1
        PUSH    BC
        CALL    tmode
        POP     BC
posy_1:
        LD      A,(__console_y)
        LD      E,A
	ld	l,a
	ld	h,0
        RET

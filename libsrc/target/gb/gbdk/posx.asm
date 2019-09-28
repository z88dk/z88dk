


        MODULE  posx
        SECTION code_driver

        PUBLIC  posx
        PUBLIC  _posx

	EXTERN	__mode
	EXTERN	__console_x
	EXTERN	tmode


        INCLUDE "target/gb/def/gb_globals.def"

; int8_t posx(void);
posx:
_posx:
        LD      A,(__mode)      ; Banked
        AND     T_MODE
        JR      NZ,posx_1
        PUSH    BC
        CALL    tmode
        POP     BC
posx_1:
        LD      A,(__console_x)
        LD      E,A
	ld	l,a
	ld	h,0
        RET

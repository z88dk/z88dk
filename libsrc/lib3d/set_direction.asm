;
;       Turtle graphics library
;       Stefano - 11/2017
;
;       $Id: set_direction.asm $
;

        SECTION   code_clib
        PUBLIC    set_direction
        PUBLIC    _set_direction

.set_direction
._set_direction
	; __FASTCALL
	ld	(__direction),hl
	ret

	
		SECTION		bss_clib
		PUBLIC		__direction

__direction:	defw		0


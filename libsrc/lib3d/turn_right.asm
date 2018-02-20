;
;       Turtle graphics library
;       Stefano - 11/2017
;
;       $Id: turn_right.asm $
;

        SECTION   code_clib
        PUBLIC    turn_right
        PUBLIC    _turn_right
        EXTERN __direction

.turn_right
._turn_right
	; __FASTCALL
	ld	de,(__direction)
	ex	de,hl
	add	hl,de
	ld	(__direction),hl
	and	a
	ld	de,360
	sbc	hl,de
	ret	c
	
	ld	(__direction),hl
	ret

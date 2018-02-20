;
;       Turtle graphics library
;       Stefano - 11/2017
;
;       $Id: turn_left.asm $
;

        SECTION   code_clib
        PUBLIC    turn_left
        PUBLIC    _turn_left
        EXTERN __direction

.turn_left
._turn_left
	; __FASTCALL
	ld	de,(__direction)
	ex	de,hl
	and	a
	sbc	hl,de
	ld	(__direction),hl
	ret	nc
	ld	de,360
	add	hl,de
	ld	(__direction),hl
	ret

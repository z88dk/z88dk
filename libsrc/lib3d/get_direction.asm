;
;       Turtle graphics library
;       Stefano - 11/2017
;
;       $Id: get_direction.asm $
;

        SECTION   code_clib
        PUBLIC    get_direction
        PUBLIC    _get_direction
        
        EXTERN __direction


.get_direction
._get_direction
	ld	hl,(__direction)
	ret

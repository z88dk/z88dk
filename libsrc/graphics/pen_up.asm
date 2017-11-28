;
;       Turtle graphics library
;       Stefano - 11/2017
;
;       $Id: pen_up.asm $
;

        SECTION   code_clib
        PUBLIC    pen_up
        PUBLIC    _pen_up
        
        EXTERN __pen


.pen_up
._pen_up
	ld	hl,__pen
	ld	a,254
	and	(hl)
	ld	(hl),a
	ret

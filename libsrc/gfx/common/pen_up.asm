;
;      Turtle graphics library
;      Stefano - 11/2017
;
;      $Id: pen_up.asm $
;

       SECTION   code_graphics
       PUBLIC    pen_up
       PUBLIC    _pen_up
       
       EXTERN __pen


.pen_up
._pen_up
	ld	hl,__pen
	ld	a,127
	and	(hl)
	ld	(hl),a
	ret

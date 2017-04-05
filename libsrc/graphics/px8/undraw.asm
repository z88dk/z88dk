;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       PX8 variant by Stefano Bodrato
;
;
;	$Id: undraw.asm - Stefano, 2017 $
;


		SECTION         code_clib
		
		PUBLIC    undraw
		PUBLIC	  _undraw
		
        EXTERN    do_draw
		EXTERN    draw_mode


.undraw
._undraw
		ld	a,1	; SET (0=set, 1=reset, 3=complement)
		ld	(draw_mode+1),a
		jp do_draw
		

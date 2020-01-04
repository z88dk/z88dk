;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       PX8 variant by Stefano Bodrato
;
;


		SECTION         code_clib
		
		PUBLIC    undraw
		PUBLIC	  _undraw
		
        EXTERN    do_draw


.undraw
._undraw
		ld	a,1
		jp do_draw
		

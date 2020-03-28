;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       PX8 variant by Stefano Bodrato
;
;


		SECTION         code_clib
		
		PUBLIC    xordraw
		PUBLIC	  _xordraw
		
        EXTERN    do_draw


.xordraw
._xordraw
		ld	a,3
		jp do_draw
		

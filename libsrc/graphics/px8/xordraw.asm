;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       PX8 variant by Stefano Bodrato
;
;
;	$Id: xordraw.asm - Stefano, 2017 $
;


		SECTION         code_clib
		
		PUBLIC    xordraw
		PUBLIC	  _xordraw
		
        EXTERN    draw
		

.xordraw
._xordraw
		jp draw

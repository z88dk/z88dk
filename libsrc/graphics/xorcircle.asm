;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: xorcircle.asm $
;


; Usage: xorcircle(int x, int y, int radius, int skip);


		SECTION     code_graphics
		
		PUBLIC      xorcircle
		PUBLIC      _xorcircle

		EXTERN      xorcircle_callee
		EXTERN      ASMDISP_XORCIRCLE_CALLEE


.xorcircle
._xorcircle
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)	;skip
		ld	d,(ix+4)	;radius
		ld	c,(ix+6)	;y
		ld	b,(ix+8)	;x
		
		jp xorcircle_callee + ASMDISP_XORCIRCLE_CALLEE

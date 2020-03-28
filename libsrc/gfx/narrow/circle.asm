;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: circle.asm $
;


; Usage: circle(int x, int y, int radius, int skip);


		SECTION     code_graphics
		
		PUBLIC      circle
		PUBLIC      _circle

		EXTERN      circle_callee
		EXTERN      ASMDISP_CIRCLE_CALLEE


.circle
._circle
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)	;skip
		ld	d,(ix+4)	;radius
		ld	c,(ix+6)	;y
		ld	b,(ix+8)	;x
		
		jp circle_callee + ASMDISP_CIRCLE_CALLEE

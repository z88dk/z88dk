;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: uncircle.asm $
;


; Usage: uncircle(int x, int y, int radius, int skip);


		SECTION     code_graphics
		
		PUBLIC      uncircle
		PUBLIC      _uncircle

		EXTERN      uncircle_callee
		EXTERN      ASMDISP_UNCIRCLE_CALLEE


.uncircle
._uncircle
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)	;skip
		ld	d,(ix+4)	;radius
		ld	c,(ix+6)	;y
		ld	b,(ix+8)	;x
		
		jp uncircle_callee + ASMDISP_UNCIRCLE_CALLEE

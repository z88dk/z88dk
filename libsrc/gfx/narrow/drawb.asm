;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;
; ----- void __CALLEE__ drawb(int x, int y, int h, int v)
;
;	$Id: drawb.asm $
;


		SECTION         code_graphics
		
		PUBLIC    drawb
		PUBLIC    _drawb

		EXTERN    drawb_callee
		EXTERN    ASMDISP_DRAWB_CALLEE


.drawb
._drawb
		push	ix
		ld	ix,2
		add	ix,sp
		ld	c,(ix+2)
		ld	b,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)
		pop	ix
		
   jp drawb_callee + ASMDISP_DRAWB_CALLEE

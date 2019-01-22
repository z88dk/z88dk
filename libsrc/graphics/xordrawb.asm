;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;
; ----- void __CALLEE__ xordrawb(int x, int y, int h, int v)
;
;	$Id: xordrawb.asm $
;


		SECTION         code_graphics
		
		PUBLIC    xordrawb
		PUBLIC    _xordrawb

		EXTERN    xordrawb_callee
		EXTERN    ASMDISP_XORDRAWB_CALLEE


.xordrawb
._xordrawb
		push	ix
		ld	ix,2
		add	ix,sp
		ld	c,(ix+2)
		ld	b,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)
		pop	ix
		
   jp xordrawb_callee + ASMDISP_XORDRAWB_CALLEE

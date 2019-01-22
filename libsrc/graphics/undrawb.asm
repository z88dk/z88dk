;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;
; ----- void __CALLEE__ undrawb(int x, int y, int h, int v)
;
;	$Id: undrawb.asm $
;


		SECTION         code_graphics
		
		PUBLIC    undrawb
		PUBLIC    _undrawb

		EXTERN    undrawb_callee
		EXTERN    ASMDISP_UNDRAWB_CALLEE


.undrawb
._undrawb
		push	ix
		ld	ix,2
		add	ix,sp
		ld	c,(ix+2)
		ld	b,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)
		pop	ix
		
   jp undrawb_callee + ASMDISP_UNDRAWB_CALLEE

;
;       Z88 Graphics Functions - Small C+ stubs
;       Written around the Interlogic Standard Library
;       Stubs Written by D Morris - 30/9/98
;
;	$Id: fillb.asm $
;


;Usage: fillb(struct *pixels)


		SECTION         code_graphics
		
		PUBLIC    fillb
		PUBLIC    _fillb
		
		EXTERN fillb_callee
		EXTERN ASMDISP_FILLB_CALLEE

.fillb
._fillb
		push	ix
		ld	ix,2
		add	ix,sp
		ld	c,(ix+2)
		ld	b,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)
		pop	ix
		
   jp fillb_callee + ASMDISP_FILLB_CALLEE

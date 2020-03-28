;
;       Z88 Graphics Functions - Small C+ stubs
;       Written around the Interlogic Standard Library
;       Stubs Written by D Morris - 30/9/98
;
;	$Id: clga.asm $
;


;Usage: clga(struct *pixels)


		SECTION         code_graphics
		
		PUBLIC    clga
		PUBLIC    _clga
		
		EXTERN clga_callee
		EXTERN ASMDISP_CLGA_CALLEE

.clga
._clga
		push	ix
		ld	ix,2
		add	ix,sp
		ld	c,(ix+2)
		ld	b,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)
		pop	ix
		
   jp clga_callee + ASMDISP_CLGA_CALLEE

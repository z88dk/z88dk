;
;       Z88 Graphics Functions - Small C+ stubs
;       Written around the Interlogic Standard Library
;       Stubs Written by D Morris - 30/9/98
;
;	$Id: xorclga.asm $
;


;Usage: xorclga(struct *pixels)


		SECTION         code_graphics
		
		PUBLIC    xorclga
		PUBLIC    _xorclga
		
		EXTERN xorclga_callee
		EXTERN ASMDISP_XORCLGA_CALLEE

.xorclga
._xorclga
		push	ix
		ld	ix,2
		add	ix,sp
		ld	c,(ix+2)
		ld	b,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)
		pop	ix
		
   jp xorclga_callee + ASMDISP_XORCLGA_CALLEE

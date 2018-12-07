;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: xordraw.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xordraw(int x, int y, int x2, int y2)


		SECTION   code_graphics
		
		PUBLIC    xordraw
		PUBLIC	  _xordraw
		
		EXTERN xordraw_callee
		EXTERN ASMDISP_XORDRAW_CALLEE


.xordraw
._xordraw
		push	ix
		ld	ix,2
		add	ix,sp
		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0
		ld	e,(ix+2)	;y1
		ld	d,(ix+4)	;x1
		pop	ix
		
   jp xordraw_callee + ASMDISP_XORDRAW_CALLEE
  

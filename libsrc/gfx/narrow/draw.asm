;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: draw.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  draw(int x, int y, int x2, int y2)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
		SECTION   code_graphics
		
		PUBLIC    draw
		PUBLIC	  _draw
		
		EXTERN draw_callee
		EXTERN ASMDISP_DRAW_CALLEE


.draw
._draw
		push	ix
		ld	ix,2
		add	ix,sp
		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0
		ld	e,(ix+2)	;y1
		ld	d,(ix+4)	;x1
		pop	ix
		
   jp draw_callee + ASMDISP_DRAW_CALLEE
  
ENDIF

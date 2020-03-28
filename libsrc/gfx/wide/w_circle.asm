;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_circle.asm $
;


IF !__CPU_INTEL__
; Usage: circle(int x, int y, int radius, int skip);


		SECTION     code_graphics
		
		PUBLIC      circle
		PUBLIC      _circle

		EXTERN      circle_callee
		EXTERN      ASMDISP_CIRCLE_CALLEE


.circle
._circle
		push	ix
		ld ix,2
		add ix,sp

;       de = x0, hl = y0, bc = radius, a = skip

		ld a,(ix+2)	;skip
		ld c,(ix+4)	;radius
		ld b,(ix+5)
		ld l,(ix+6)	;y
		ld h,(ix+7)
		ld e,(ix+8)	;x
		ld d,(ix+9)

		
		jp circle_callee + ASMDISP_CIRCLE_CALLEE
ENDIF

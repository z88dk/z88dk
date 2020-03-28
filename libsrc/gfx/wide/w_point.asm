;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_point.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  point(int x, int y)
;Result is true/false


		SECTION   code_graphics
		
		PUBLIC    point
		PUBLIC	  _point
		
		EXTERN point_callee
		EXTERN ASMDISP_POINT_CALLEE

.point
._point

   pop af
   pop de	; y
   pop hl	; x
   push hl
   push de
   push af

   jp point_callee + ASMDISP_POINT_CALLEE
   

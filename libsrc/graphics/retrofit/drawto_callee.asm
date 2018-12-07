;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (int type parameters) version by Stefano Bodrato
;

;
;	$Id: drawto_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  drawto(int x2, int y2)


SECTION   code_graphics

PUBLIC     drawto
PUBLIC    _drawto

EXTERN    drawto_callee
EXTERN    ASMDISP_DRAWTO_CALLEE


.drawto
._drawto
	ld	hl,retaddr
	ex (sp),hl
	ld	hl,drawto
	jp (hl)
	
.retaddr
   pop af
   pop de
   pop hl
   push af
	
jp drawto_callee + ASMDISP_DRAWTO_CALLEE


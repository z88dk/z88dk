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
;	$Id: drawr_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  drawr(int x2, int y2)


SECTION   code_graphics

PUBLIC     drawr
PUBLIC    _drawr

EXTERN    drawr_callee
EXTERN    ASMDISP_DRAWR_CALLEE


.drawr
._drawr
	ld	hl,retaddr
	ex (sp),hl
	ld	hl,drawr
	jp (hl)
	
.retaddr
   pop af
   pop de
   pop hl
   push af
	
jp drawr_callee + ASMDISP_DRAWR_CALLEE


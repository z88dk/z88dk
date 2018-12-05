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
;	$Id: undrawr_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  undrawr(int x2, int y2)


SECTION   code_graphics

PUBLIC     undrawr
PUBLIC    _undrawr

EXTERN    undrawr_callee
EXTERN    ASMDISP_UNDRAWR_CALLEE


.undrawr
._undrawr
	ld	hl,retaddr
	ex (sp),hl
	ld	hl,undrawr
	jp (hl)
	
.retaddr
   pop af
   pop de
   pop hl
   push af
	
jp undrawr_callee + ASMDISP_UNDRAWR_CALLEE


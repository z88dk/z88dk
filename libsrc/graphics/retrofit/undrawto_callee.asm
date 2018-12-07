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
;	$Id: undrawto_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  undrawto(int x2, int y2)


SECTION   code_graphics

PUBLIC     undrawto
PUBLIC    _undrawto

EXTERN    undrawto_callee
EXTERN    ASMDISP_UNDRAWTO_CALLEE


.undrawto
._undrawto
	ld	hl,retaddr
	ex (sp),hl
	ld	hl,undrawto
	jp (hl)
	
.retaddr
   pop af
   pop de
   pop hl
   push af
	
jp undrawto_callee + ASMDISP_UNDRAWTO_CALLEE


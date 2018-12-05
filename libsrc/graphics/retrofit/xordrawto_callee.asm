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
;	$Id: xordrawto_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xordrawto(int x2, int y2)


SECTION   code_graphics

PUBLIC     xordrawto
PUBLIC    _xordrawto

EXTERN    xordrawto_callee
EXTERN    ASMDISP_XORDRAWTO_CALLEE


.xordrawto
._xordrawto
	ld	hl,retaddr
	ex (sp),hl
	ld	hl,xordrawto
	jp (hl)
	
.retaddr
   pop af
   pop de
   pop hl
   push af
	
jp xordrawto_callee + ASMDISP_XORDRAWTO_CALLEE


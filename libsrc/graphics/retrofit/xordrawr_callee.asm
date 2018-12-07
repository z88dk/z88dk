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
;	$Id: xordrawr_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xordrawr(int x2, int y2)


SECTION   code_graphics

PUBLIC     xordrawr
PUBLIC    _xordrawr

EXTERN    xordrawr_callee
EXTERN    ASMDISP_XORDRAWR_CALLEE


.xordrawr
._xordrawr
	ld	hl,retaddr
	ex (sp),hl
	ld	hl,xordrawr
	jp (hl)
	
.retaddr
   pop af
   pop de
   pop hl
   push af
	
jp xordrawr_callee + ASMDISP_XORDRAWR_CALLEE


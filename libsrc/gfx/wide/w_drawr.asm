;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (int type parameters) version by Stefano Bodrato
;
;	$Id: w_drawr.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC drawr
PUBLIC _drawr
EXTERN drawr_callee
EXTERN ASMDISP_DRAWR_CALLEE

.drawr
._drawr

		pop	af
		;pop bc
		pop	de
		pop	hl
		push	hl
		push	de
		;push	bc
		push	af


   jp drawr_callee + ASMDISP_DRAWR_CALLEE
ENDIF

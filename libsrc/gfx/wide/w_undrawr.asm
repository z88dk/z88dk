;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (int type parameters) version by Stefano Bodrato
;
;	$Id: w_undrawr.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC undrawr
PUBLIC _undrawr
EXTERN undrawr_callee
EXTERN ASMDISP_UNDRAWR_CALLEE

.undrawr
._undrawr

		pop	af
		pop	de
		pop	hl
		push	hl
		push	de
		push	af


   jp undrawr_callee + ASMDISP_UNDRAWR_CALLEE
ENDIF

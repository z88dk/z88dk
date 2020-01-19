;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (int type parameters) version by Stefano Bodrato
;
;	$Id: w_undrawto.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC undrawto
PUBLIC _undrawto
EXTERN undrawto_callee
EXTERN ASMDISP_UNDRAWTO_CALLEE

.undrawto
._undrawto

		pop	af
		pop	de
		pop	hl
		push	hl
		push	de
		push	af


   jp undrawto_callee + ASMDISP_UNDRAWTO_CALLEE
ENDIF

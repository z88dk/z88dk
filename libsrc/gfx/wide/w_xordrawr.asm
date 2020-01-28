;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (int type parameters) version by Stefano Bodrato
;
;	$Id: w_xordrawr.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC xordrawr
PUBLIC _xordrawr
EXTERN xordrawr_callee
EXTERN ASMDISP_XORDRAWR_CALLEE

.xordrawr
._xordrawr

		pop	af
		pop	de
		pop	hl
		push	hl
		push	de
		push	af


   jp xordrawr_callee + ASMDISP_XORDRAWR_CALLEE
ENDIF

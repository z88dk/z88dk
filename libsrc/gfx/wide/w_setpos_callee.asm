;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
; ----- void __CALLEE__ setpos(int x2, int y2)
;
;	$Id: w_setpos_callee.asm $
;

	SECTION   code_graphics

	PUBLIC    setpos_callee
	PUBLIC    _setpos_callee
	
	PUBLIC    ASMDISP_SETPOS_CALLEE

	EXTERN	w_setxy


.setpos_callee
._setpos_callee	
	pop	af	; ret addr
	pop de
	pop hl
	push	af	; ret addr
	
.asmentry
	jp	w_setxy


DEFC ASMDISP_SETPOS_CALLEE = asmentry - setpos_callee

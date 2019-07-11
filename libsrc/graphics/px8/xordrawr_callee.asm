;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       PX8 variant by Stefano Bodrato
;
; ----- void __CALLEE__ xordrawr(int x2, int y2)
;
;	$Id: xordrawr_callee.asm $
;

	SECTION   code_graphics

	PUBLIC    xordrawr_callee
	PUBLIC    _xordrawr_callee
	
	PUBLIC    ASMDISP_XORDRAWR_CALLEE

	EXTERN    do_drawr


.xordrawr_callee
._xordrawr_callee	
	pop	af	; ret addr
	pop de	; y
	pop hl	; x
	push	af	; ret addr
	
.asmentry
	ld		a,3
	jp      do_drawr


DEFC ASMDISP_XORDRAWR_CALLEE = # asmentry - xordrawr_callee

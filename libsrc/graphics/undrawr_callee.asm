;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
; ----- void __CALLEE__ undrawr(int x2, int y2)
;
;	$Id: undrawr_callee.asm $
;

	SECTION   code_graphics

	PUBLIC    undrawr_callee
	PUBLIC    _undrawr_callee
	
	PUBLIC    ASMDISP_UNDRAWR_CALLEE

	EXTERN    swapgfxbk
	EXTERN    __graphics_end
	
	EXTERN    Line_r
	EXTERN    respixel


.undrawr_callee
._undrawr_callee	
	pop	af	; ret addr
	pop de	; y
	pop hl	; x
	push	af	; ret addr
	
.asmentry
	push	ix
	call    swapgfxbk
	ld      ix,respixel
	call    Line_r
	jp      __graphics_end


DEFC ASMDISP_UNDRAWR_CALLEE = asmentry - undrawr_callee

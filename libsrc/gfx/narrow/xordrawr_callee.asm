;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
; ----- void __CALLEE__ xordrawr(int x2, int y2)
;
;	$Id: xordrawr_callee.asm $
;

IF !__CPU_INTEL__ & !__CPU_GBZ80__
	SECTION   code_graphics

	PUBLIC    xordrawr_callee
	PUBLIC    _xordrawr_callee
	
	PUBLIC    ASMDISP_XORDRAWR_CALLEE

	EXTERN    swapgfxbk
	EXTERN    __graphics_end
	
	EXTERN    Line_r
	EXTERN    xorpixel


.xordrawr_callee
._xordrawr_callee	
	pop	af	; ret addr
	pop de	; y
	pop hl	; x
	push	af	; ret addr
	
.asmentry
	push	ix
	call    swapgfxbk
	ld      ix,xorpixel
	call    Line_r
	jp      __graphics_end


DEFC ASMDISP_XORDRAWR_CALLEE = asmentry - xordrawr_callee
ENDIF

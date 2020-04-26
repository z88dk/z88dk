;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
; ----- void __CALLEE__ undraw(int x, int y, int x2, int y2)
;
;	$Id: undraw_callee.asm $
;

IF !__CPU_INTEL__ & !__CPU_GBZ80__
	SECTION   code_graphics

	PUBLIC    undraw_callee
	PUBLIC    _undraw_callee
	
	PUBLIC    ASMDISP_UNDRAW_CALLEE

	EXTERN    swapgfxbk
	EXTERN    __graphics_end
	
	EXTERN    Line
	EXTERN    respixel


.undraw_callee
._undraw_callee	
	pop	af	; ret addr
	pop de	; y2
	pop hl
	ld	d,l	; x2
	pop hl	; y
	pop bc
	ld	h,c	; x
	push	af	; ret addr
	
.asmentry
	push	ix
	call    swapgfxbk
	push	hl
	push    de
	call	respixel
	pop     de
	pop	hl
		ld      ix,respixel
		call    Line
	jp	__graphics_end


DEFC ASMDISP_UNDRAW_CALLEE = asmentry - undraw_callee
ENDIF

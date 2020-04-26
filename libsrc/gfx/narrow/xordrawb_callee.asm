;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;
; ----- void __CALLEE__ xordrawb(int x, int y, int h, int v)
;
;	$Id: xordrawb_callee.asm $
;


IF !__CPU_INTEL__ & !__CPU_GBZ80__
		SECTION         code_graphics
		
		PUBLIC    xordrawb_callee
		PUBLIC    _xordrawb_callee

		PUBLIC    ASMDISP_XORDRAWB_CALLEE

		EXTERN     drawbox
		EXTERN     xorpixel
		EXTERN     swapgfxbk
		EXTERN        __graphics_end


.xordrawb_callee
._xordrawb_callee
		pop af
		pop bc	; height
		pop de
		ld	b,e	; width
		pop hl	; x
		pop	de
		ld	h,e	; y		
		push af
		
.asmentry
				push ix
                ld      ix,xorpixel
                call    swapgfxbk
                call    drawbox
                jp      __graphics_end

DEFC ASMDISP_XORDRAWB_CALLEE = asmentry - xordrawb_callee
ENDIF

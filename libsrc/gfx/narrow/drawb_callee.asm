;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;
; ----- void __CALLEE__ drawb(int x, int y, int h, int v)
;
;	$Id: drawb_callee.asm $
;


IF !__CPU_INTEL__ & !__CPU_GBZ80__
		SECTION         code_graphics
		
		PUBLIC    drawb_callee
		PUBLIC    _drawb_callee

		PUBLIC    ASMDISP_DRAWB_CALLEE

		EXTERN     drawbox
		EXTERN     plotpixel
		EXTERN     swapgfxbk
		EXTERN        __graphics_end


.drawb_callee
._drawb_callee
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
                ld      ix,plotpixel
                call    swapgfxbk
                call    drawbox
                jp      __graphics_end

DEFC ASMDISP_DRAWB_CALLEE = asmentry - drawb_callee
ENDIF

;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_xorplot_callee.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xorplot(int x, int y)


        SECTION code_graphics
		
                PUBLIC    xorplot_callee
                PUBLIC    _xorplot_callee
				PUBLIC    ASMDISP_XORPLOT_CALLEE
				
                EXTERN     swapgfxbk
                EXTERN    __graphics_end

                EXTERN     w_xorpixel

.xorplot_callee
._xorplot_callee

   pop af
   pop de	; y
   pop hl	; x
   push af

.asmentry
		push	ix
                call    swapgfxbk
                call    w_xorpixel
                jp      __graphics_end

DEFC ASMDISP_XORPLOT_CALLEE = asmentry - xorplot_callee

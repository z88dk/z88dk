;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_plot_callee.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  plot(int x, int y)


        SECTION code_graphics
		
                PUBLIC    plot_callee
                PUBLIC    _plot_callee
				PUBLIC    ASMDISP_PLOT_CALLEE
				
                EXTERN     swapgfxbk
                EXTERN    __graphics_end

                EXTERN     w_plotpixel

.plot_callee
._plot_callee

   pop af
   pop de	; y
   pop hl	; x
   push af

.asmentry
		push	ix
                call    swapgfxbk
                call    w_plotpixel
                jp      __graphics_end

DEFC ASMDISP_PLOT_CALLEE = asmentry - plot_callee

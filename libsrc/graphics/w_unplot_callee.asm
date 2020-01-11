;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_unplot_callee.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  unplot(int x, int y)


        SECTION code_graphics
		
                PUBLIC    unplot_callee
                PUBLIC    _unplot_callee
				PUBLIC    ASMDISP_UNPLOT_CALLEE
				
                EXTERN     swapgfxbk
                EXTERN    __graphics_end

                EXTERN     w_respixel

.unplot_callee
._unplot_callee

   pop bc
   pop de	; y
   pop hl	; x
   push bc

.asmentry
IF !__CPU_INTEL__
		push	ix
ENDIF
                call    swapgfxbk
                call    w_respixel
                jp      __graphics_end

DEFC ASMDISP_UNPLOT_CALLEE = asmentry - unplot_callee

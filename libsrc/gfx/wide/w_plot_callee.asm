;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Written around the Interlogic Standard Library
;
;      Stubs Written by D Morris - 30/9/98
;
;
;    $Id: w_plot_callee.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  plot(int x, int y)


    SECTION code_graphics

    PUBLIC    plot_callee
    PUBLIC    _plot_callee
    PUBLIC    ASMDISP_PLOT_CALLEE

    EXTERN    swapgfxbk
    EXTERN    __graphics_end

    EXTERN    w_plotpixel
    INCLUDE "graphics/grafix.inc"


.plot_callee
._plot_callee

    pop bc
    pop de    ; y
    pop hl    ; x
    push bc

.asmentry
IF !__CPU_INTEL__
    push    ix
ENDIF
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF    
    call    w_plotpixel
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
DEFC ASMDISP_PLOT_CALLEE = asmentry - plot_callee

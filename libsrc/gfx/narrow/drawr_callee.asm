;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;     Stubs Written by D Morris - 30/9/98
;
; ----- void __CALLEE__ drawr(int x2, int y2)
;
;    $Id: drawr_callee.asm $
;

IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION   code_graphics

    PUBLIC    drawr_callee
    PUBLIC    _drawr_callee
    
    PUBLIC    ASMDISP_DRAWR_CALLEE

    EXTERN    swapgfxbk
    EXTERN    __graphics_end
    
    EXTERN    Line_r
    EXTERN    plotpixel
    INCLUDE "graphics/grafix.inc"


.drawr_callee
._drawr_callee    
    pop    af    ; ret addr
    pop de    ; y
    pop hl    ; x
    push    af    ; ret addr
    
.asmentry
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    ld    ix,plotpixel
    call    Line_r
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

DEFC ASMDISP_DRAWR_CALLEE = asmentry - drawr_callee
ENDIF

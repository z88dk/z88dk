;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;     Stubs Written by D Morris - 30/9/98
;
; ----- void __CALLEE__ drawto(int x2, int y2)
;
;    $Id: drawto_callee.asm $
;

IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION   code_graphics

    PUBLIC    drawto_callee
    PUBLIC    _drawto_callee
    
    PUBLIC    ASMDISP_DRAWTO_CALLEE

    EXTERN    swapgfxbk
    EXTERN    __graphics_end
    
    EXTERN    Line
    EXTERN    plotpixel

    EXTERN    __gfx_coords
    INCLUDE "graphics/grafix.inc"


.drawto_callee
._drawto_callee    
    pop    af    ; ret addr
    pop de    ; y2
    pop hl
    ld    d,l    ; x2
    push    af    ; ret addr
    
.asmentry
    ld    hl,(__gfx_coords)
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    push    hl
    push    de
    call    plotpixel
    pop    de
    pop    hl
    ld    ix,plotpixel
    call    Line
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

DEFC ASMDISP_DRAWTO_CALLEE = asmentry - drawto_callee
ENDIF

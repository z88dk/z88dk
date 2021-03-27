;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Written around the Interlogic Standard Library
;
;      Stubs Written by D Morris - 30/9/98
;
;
;    $Id: w_xorcircle_callee.asm $
;


; Usage: xorcircle(int x, int y, int radius, int skip);


IF !__CPU_INTEL__
    SECTION        code_graphics
    
    PUBLIC    xorcircle_callee
    PUBLIC    _xorcircle_callee
    
    PUBLIC    ASMDISP_XORCIRCLE_CALLEE

    EXTERN    w_draw_circle
    EXTERN    w_xorpixel
    
    EXTERN    swapgfxbk
    EXTERN    __graphics_end
    INCLUDE "graphics/grafix.inc"

    
.xorcircle_callee
._xorcircle_callee

;      de = x0, hl = y0, bc = radius, a = skip

    pop    af
    ex    af,af

    pop    de    ; skip
    ld    a,e
    pop    bc    ;radius
    pop    hl    ; y
    pop    de    ; x

    ex    af,af
    push    af
    ex    af,af

    push    ix
.asmentry
    push    af
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    pop    af
    ld     ix,w_xorpixel
    call    w_draw_circle
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
DEFC ASMDISP_XORCIRCLE_CALLEE = asmentry - xorcircle_callee
ENDIF

;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;     Stubs Written by D Morris - 30/9/98
;
;
;    $Id: xorcircle_callee.asm $
;


; Usage: xorcircle(int x, int y, int radius, int skip);


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION    code_graphics
    
    PUBLIC    xorcircle_callee
    PUBLIC    _xorcircle_callee
    
    PUBLIC    ASMDISP_XORCIRCLE_CALLEE

    EXTERN    draw_circle
    EXTERN    xorpixel
    
    EXTERN    swapgfxbk
    EXTERN    __graphics_end
    INCLUDE    "graphics/grafix.inc"

    
.xorcircle_callee
._xorcircle_callee
    pop    af

    pop    de    ; skip
    pop    bc    ;radius
    ld    d,c
    pop    bc    ; y
    pop    hl    ; x
    ld    b,l

    push    af

    push    ix
    
    
.asmentry
    ld    ix,xorpixel
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF    
    call    draw_circle
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

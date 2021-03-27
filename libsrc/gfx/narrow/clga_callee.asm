;
;     Z88 Graphics Functions - Small C+ stubs
;     Written around the Interlogic Standard Library
;     Stubs Written by D Morris - 30/9/98
;
;    $Id: clga_callee.asm $
;


;Usage: clga(struct *pixels)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION    code_graphics
    
    PUBLIC    clga_callee
    PUBLIC    _clga_callee

    PUBLIC    ASMDISP_CLGA_CALLEE
    
    EXTERN    swapgfxbk
    EXTERN    __graphics_end
    
    EXTERN    cleararea
    INCLUDE "graphics/grafix.inc"


.clga_callee
._clga_callee
    
    pop    af    ; ret addr
    pop bc    ; y2
    pop hl
    ld    b,l    ; x2
    pop hl    ; y
    pop de
    ld    h,e    ; x
    push    af    ; ret addr
    
.asmentry
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    call    cleararea
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

DEFC ASMDISP_CLGA_CALLEE = asmentry - clga_callee
ENDIF

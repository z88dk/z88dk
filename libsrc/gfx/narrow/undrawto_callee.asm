;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;     Stubs Written by D Morris - 30/9/98
;
; ----- void __CALLEE__ undrawto(int x2, int y2)
;
;    $Id: undrawto_callee.asm $
;

IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION   code_graphics

    PUBLIC    undrawto_callee
    PUBLIC    _undrawto_callee
    
    PUBLIC    ASMDISP_UNDRAWTO_CALLEE

    EXTERN    swapgfxbk
    EXTERN    __graphics_end
    
    EXTERN    Line
    EXTERN    respixel

    EXTERN    __gfx_coords
    INCLUDE    "graphics/grafix.inc"


.undrawto_callee
._undrawto_callee    
    pop    af    ; ret addr
    pop    de    ; y2
    pop    hl
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
    call    respixel
    pop    de
    pop    hl
    ld    ix,respixel
    call    Line
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

DEFC ASMDISP_UNDRAWTO_CALLEE = asmentry - undrawto_callee
ENDIF

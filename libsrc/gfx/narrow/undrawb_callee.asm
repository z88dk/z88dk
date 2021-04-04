; ----- void __CALLEE__ undrawb(int x, int y, int h, int v)

IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  undrawb_callee
    PUBLIC  _undrawb_callee

    PUBLIC  asm_undrawb
    
    EXTERN  drawbox
    EXTERN  respixel
    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"


.undrawb_callee
._undrawb_callee
    pop     af
    pop     bc    ; height
    pop     de
    ld      b,e    ; width
    pop     hl    ; x
    pop     de
    ld      h,e    ; y    
    push    af
    
.asm_undrawb
    push    ix
    ld      ix,respixel
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF    
    call    drawbox
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
ENDIF

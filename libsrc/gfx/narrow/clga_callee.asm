;Usage: clga(int tlx, int tly, int tlx2, int tly2)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  clga_callee
    PUBLIC  _clga_callee

    PUBLIC  asm_clga
    
    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    
    EXTERN  cleararea
    INCLUDE "graphics/grafix.inc"


.clga_callee
._clga_callee
    pop     af    ; ret addr
    pop     bc    ; y2
    pop     hl
    ld      b,l    ; x2
    pop     hl    ; y
    pop     de
    ld      h,e    ; x
    push    af    ; ret addr
    
.asm_clga
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    call    cleararea
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
    pop     ix
    ret
ENDIF

ENDIF

; ----- int point_callee(int x, int y)
;Result is true/false

IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  point_callee
    PUBLIC  _point_callee
    PUBLIC  asm_point
    
    EXTERN    swapgfxbk
    EXTERN    swapgfxbk1

    EXTERN    w_pointxy
    INCLUDE "graphics/grafix.inc"


.point_callee
._point_callee
    pop     bc
    pop     de    ; y
    pop     hl    ; x
    push    bc

.asm_point
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF             
    call    w_pointxy
IF NEED_swapgfxbk = 1
    push    af
    call    swapgfxbk1
    pop     af
ENDIF
    pop     ix
    ld      hl,1
    ret     nz      ;pixel set
    dec     hl
    ret
ENDIF


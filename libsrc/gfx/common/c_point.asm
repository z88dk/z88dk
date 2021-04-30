;Usage: c_point(struct *pixel)
;Result is true/false


    SECTION	  code_graphics
    PUBLIC    c_point
    PUBLIC    _c_point

    EXTERN    c_pointxy
    EXTERN    swapgfxbk
    EXTERN    swapgfxbk1
    INCLUDE "graphics/grafix.inc"


.c_point
._c_point
IF __CPU_INTEL__ | __CPU_GBZ80__
    pop    bc
    pop    hl
    pop    de
    push    de
    push    hl
    push    bc
    ld     h,e
ELSE
    push    ix
    ld     ix,2
    add    ix,sp
    ld     l,(ix+2)
    ld     h,(ix+4)
ENDIF
IF NEED_swapgfxbk = 1
       call    swapgfxbk
ENDIF
       call    c_pointxy
IF NEED_swapgfxbk = 1
    push    af
    call    swapgfxbk1
    pop    af
ENDIF
IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop	ix
ENDIF
    ld     hl,1
    ret    nz      ;pixel set
    dec    hl
    ret


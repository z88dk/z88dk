; ----- int point_callee(int x, int y)
;Result is true/false


  IF    !__CPU_INTEL__&!__CPU_GBZ80__


        SECTION code_graphics

        PUBLIC  point_callee
        PUBLIC  _point_callee
        PUBLIC  asm_point

        EXTERN  swapgfxbk
        EXTERN  swapgfxbk1

        EXTERN  pointxy
        INCLUDE "graphics/grafix.inc"


point_callee:
_point_callee:

        pop     af                      ; ret addr
        pop     hl                      ; y
        pop     de
        ld      h, e                    ; x
        push    af                      ; ret addr

asm_point:
        push    ix
    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
        call    pointxy

        push    af
    IF  NEED_swapgfxbk=1
        call    swapgfxbk1
    ENDIF
        pop     af
        pop     ix
        ld      hl, 1
        ret     nz                      ;pixel set
        dec     hl
        ret
  ENDIF

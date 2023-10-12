; ----- void  drawto(int x2, int y2)

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  drawto
        PUBLIC  _drawto
        PUBLIC  ___drawto

        EXTERN  asm_drawto

drawto:
_drawto:
___drawto:
        pop     af                      ; ret addr
        pop     de                      ; y2
        pop     hl
        push    hl
        push    de
        ld      d, l                    ; x2
        push    af                      ; ret addr
        jp      asm_drawto
  ENDIF

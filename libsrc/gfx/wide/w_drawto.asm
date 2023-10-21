; ----- void drawto(int x, int y)


  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  drawto
        PUBLIC  _drawto
        PUBLIC  ___drawto
        EXTERN  asm_drawto

drawto:
_drawto:
___drawto:
        pop     af
        pop     de
        pop     hl
        push    hl
        push    de
        push    af
        jp      asm_drawto
  ENDIF

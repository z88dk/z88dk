;void fillb(int tlx, int tly, int width, int height)

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  fillb
        PUBLIC  _fillb
        PUBLIC  ___fillb

        EXTERN  asm_fillb

fillb:
_fillb:
___fillb:
        push    ix
        ld      ix, 2
        add     ix, sp
        ld      c, (ix+2)
        ld      b, (ix+4)
        ld      l, (ix+6)
        ld      h, (ix+8)
        pop     ix
        jp      asm_fillb
  ENDIF

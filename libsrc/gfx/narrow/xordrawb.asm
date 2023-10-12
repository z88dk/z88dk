; ----- void __CALLEE__ xordrawb(int x, int y, int h, int v)

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  xordrawb
        PUBLIC  _xordrawb
        PUBLIC  ___xordrawb

        EXTERN  asm_xordrawb

xordrawb:
_xordrawb:
___xordrawb:
        push    ix
        ld      ix, 2
        add     ix, sp
        ld      c, (ix+2)
        ld      b, (ix+4)
        ld      l, (ix+6)
        ld      h, (ix+8)
        pop     ix
        jp      asm_xordrawb
  ENDIF

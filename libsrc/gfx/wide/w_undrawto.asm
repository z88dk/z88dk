; ----- void undrawto(int x, int y)


  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  undrawto
        PUBLIC  _undrawto
        PUBLIC  ___undrawto
        EXTERN  asm_undrawto

undrawto:
_undrawto:
___undrawto:
        pop     af
        pop     de
        pop     hl
        push    hl
        push    de
        push    af
        jp      asm_undrawto
  ENDIF

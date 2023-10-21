; ----- void undrawr(int x, int y)


  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  undrawr
        PUBLIC  _undrawr
        PUBLIC  ___undrawr
        EXTERN  asm_undrawr

undrawr:
_undrawr:
___undrawr:
        pop     af
        pop     de
        pop     hl
        push    hl
        push    de
        push    af
        jp      asm_undrawr
  ENDIF

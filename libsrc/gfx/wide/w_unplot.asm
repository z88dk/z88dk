; ----- void  unplot(int x, int y)


  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  unplot
        PUBLIC  _unplot
        PUBLIC  ___unplot

        EXTERN  asm_unplot

unplot:
_unplot:
___unplot:
        pop     bc
        pop     de                      ; y
        pop     hl                      ; x
        push    hl
        push    de
        push    bc
        jp      asm_unplot

  ENDIF

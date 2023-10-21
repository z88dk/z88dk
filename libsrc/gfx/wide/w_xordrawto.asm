; void xordrawto(int x2, int y2);

  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  xordrawto
        PUBLIC  _xordrawto
        PUBLIC  ___xordrawto
        EXTERN  asm_xordrawto


xordrawto:
_xordrawto:
___xordrawto:
        pop     bc
        pop     de
        pop     hl
        push    hl
        push    de
        push    bc
        jp      asm_xordrawto
  ENDIF

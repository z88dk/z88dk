;void drawr(int px, int py)

  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  drawr
        PUBLIC  _drawr
        PUBLIC  ___drawr
        EXTERN  asm_drawr

drawr:
_drawr:
___drawr:
        pop     af
        pop     de
        pop     hl
        push    hl
        push    de
        push    af
        jp      asm_drawr
  ENDIF

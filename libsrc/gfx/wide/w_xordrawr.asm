; void xordrawr(int px, int py)
  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  xordrawr
        PUBLIC  _xordrawr
        PUBLIC  ___xordrawr
        EXTERN  asm_xordrawr

xordrawr:
_xordrawr:
___xordrawr:
        pop     bc
        pop     de
        pop     hl
        push    hl
        push    de
        push    bc
        jp      asm_xordrawr
  ENDIF

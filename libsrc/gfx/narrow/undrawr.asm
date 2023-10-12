; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  undrawr(int x2, int y2)


  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  undrawr
        PUBLIC  _undrawr
        PUBLIC  ___undrawr

        EXTERN  asm_undrawr

undrawr:
_undrawr:
___undrawr:
        pop     af                      ; ret addr
        pop     de                      ; y
        pop     hl                      ; x
        push    hl
        push    de
        push    af                      ; ret addr
        jp      asm_undrawr
  ENDIF

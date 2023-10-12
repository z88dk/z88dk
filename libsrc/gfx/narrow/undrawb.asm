; ----- void __CALLEE__ undrawb(int x, int y, int h, int v)
;
;    $Id: undrawb.asm $
;


  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  undrawb
        PUBLIC  _undrawb
        PUBLIC  ___undrawb

        EXTERN  asm_undrawb


undrawb:
_undrawb:
___undrawb:
        push    ix
        ld      ix, 2
        add     ix, sp
        ld      c, (ix+2)
        ld      b, (ix+4)
        ld      l, (ix+6)
        ld      h, (ix+8)
        pop     ix
        jp      asm_undrawb
  ENDIF

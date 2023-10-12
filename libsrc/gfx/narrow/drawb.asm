;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;
; ----- void __CALLEE__ drawb(int x, int y, int h, int v)
;
;    $Id: drawb.asm $
;


  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  drawb
        PUBLIC  _drawb
        PUBLIC  ___drawb

        EXTERN  asm_drawb


drawb:
_drawb:
___drawb:
        push    ix
        ld      ix, 2
        add     ix, sp
        ld      c, (ix+2)
        ld      b, (ix+4)
        ld      l, (ix+6)
        ld      h, (ix+8)
        pop     ix

        jp      asm_drawb
  ENDIF

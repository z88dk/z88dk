;
;      Z88DK Graphics Functions - Small C+ stubs
;
;	$Id: xorplot.asm,v 1.5 2016-04-22 20:17:17 dom Exp $
;

;Usage: xorplot(int x, int y)

        SECTION code_graphics
        PUBLIC  c_xorplot
        PUBLIC  _c_xorplot
        PUBLIC  ___c_xorplot
        EXTERN  swapgfxbk
        EXTERN  __graphics_end

        EXTERN  c_xorpixel
        INCLUDE "graphics/grafix.inc"

c_xorplot:
_c_xorplot:
___c_xorplot:
  IF    __CPU_INTEL__|__CPU_GBZ80__
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        ld      h, e
  ELSE
        push    ix
        ld      ix, 2
        add     ix, sp
        ld      l, (ix+2)
        ld      h, (ix+4)
  ENDIF
  IF    NEED_swapgfxbk=1
        call    swapgfxbk
  ENDIF
        call    c_xorpixel
  IF    NEED_swapgfxbk
        jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
        pop     ix
    ENDIF
        ret
  ENDIF

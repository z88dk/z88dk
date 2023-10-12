;Usage: void lscroll(int x, int y, int width, int height, int pixels)

  IF    !__CPU_GBZ80__&!__CPU_INTEL__

        SECTION code_graphics
        PUBLIC  lscroll
        PUBLIC  _lscroll
        PUBLIC  ___lscroll

        EXTERN  scroll_left



lscroll:
_lscroll:
___lscroll:
        push    ix
        ld      ix, 2
        add     ix, sp
        ld      a, (ix+2)
        ld      c, (ix+4)
        ld      b, (ix+6)
        ld      l, (ix+8)
        ld      h, (ix+10)
        pop     ix
        jp      scroll_left
  ENDIF

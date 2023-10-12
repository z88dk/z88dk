; ----- void  xordraw(int x, int y, int x2, int y2)

  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  xordraw
        PUBLIC  _xordraw
        PUBLIC  ___xordraw
        EXTERN  asm_xordraw

xordraw:
_xordraw:
___xordraw:
        pop     af
        pop     de                      ;y2
        pop     hl                      ;x2
        exx                             ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
        pop     de                      ;y1
        pop     hl                      ;x1
        push    hl
        push    de
        exx
        push    hl
        push    de
        exx
        push    af                      ; ret addr
        jp      asm_xordraw
  ENDIF

; void xordrawb(int tlx, int tly, int width, int height)
  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  xordrawb
        PUBLIC  _xordrawb
        PUBLIC  ___xordrawb
        EXTERN  asm_xordrawb

xordrawb:
_xordrawb:
___xordrawb:
        pop     af
        pop     de
        pop     hl
        exx                             ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
        pop     de
        pop     hl
        push    hl
        push    de
        exx
        push    hl
        push    de
        push    af                      ; ret addr
        jp      asm_xordrawb
  ENDIF


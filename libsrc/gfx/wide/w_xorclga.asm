;void xorclga(int tlx, int tly, int tlx2, int tly2)

  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  xorclga
        PUBLIC  _xorclga
        PUBLIC  ___xorclga
        EXTERN  asm_xorclga

xorclga:
_xorclga:
___xorclga:
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
        jp      asm_xorclga
  ENDIF

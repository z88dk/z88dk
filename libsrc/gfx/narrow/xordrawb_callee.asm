; ----- void __CALLEE__ xordrawb(int x, int y, int h, int v)


  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  xordrawb_callee
        PUBLIC  _xordrawb_callee

        PUBLIC  asm_xordrawb

        EXTERN  drawbox
        EXTERN  xorpixel
        EXTERN  swapgfxbk
        EXTERN  __graphics_end


xordrawb_callee:
_xordrawb_callee:
        pop     af
        pop     bc                      ; height
        pop     de
        ld      b, e                    ; width
        pop     hl                      ; x
        pop     de
        ld      h, e                    ; y
        push    af

asm_xordrawb:
        push    ix
        ld      ix, xorpixel
    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
        call    drawbox
    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
      IF    !__CPU_INTEL__&!__CPU_GBZ80__
        pop     ix
      ENDIF
        ret
    ENDIF
  ENDIF

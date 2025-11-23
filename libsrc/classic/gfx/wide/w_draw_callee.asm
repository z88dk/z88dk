; ----- void __CALLEE__ draw(int x, int y, int x2, int y2)

IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  draw_callee
    PUBLIC  _draw_callee
    PUBLIC  asm_draw

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out
    EXTERN  w_line_r
    EXTERN  w_plotpixel
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"

draw_callee:
_draw_callee:
    pop     af
    pop     de                          ;y2
    pop     hl                          ;x2
    exx                                 ; w_plotpixel and __gfx_vram_page_in must not use the alternate registers, no problem with w_line_r
    pop     de                          ;y1
    pop     hl                          ;x1
    push    af                          ; ret addr

; de = x1, hl = y1, hl'=x2, de'=y2
asm_draw:
    push    ix
    push    hl                          ;x1
    push    de                          ;y1
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    call    w_plotpixel

    exx
    ex      de, hl
    pop     bc                          ;y1
    or      a
    sbc     hl, bc
    ex      de, hl

    pop     bc                          ;x1
    or      a
    sbc     hl, bc

    ld      ix, w_plotpixel
    call    w_line_r
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

ENDIF

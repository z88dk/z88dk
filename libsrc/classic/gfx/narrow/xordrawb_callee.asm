; ----- void __CALLEE__ xordrawb(int x, int y, int h, int v)
;
;    $Id: xordrawb_callee.asm $
;

   SECTION code_graphics

    PUBLIC  xordrawb_callee
    PUBLIC  _xordrawb_callee

    PUBLIC  asm_xordrawb

    EXTERN  drawbox
    EXTERN  xorpixel
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


xordrawb_callee:
_xordrawb_callee:
    pop     af
    pop     bc                          ; height
    pop     de
    ld      b, e                        ; width
    pop     hl                          ; x
    pop     de
    ld      h, e                        ; y
    push    af

asm_xordrawb:
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
    ld      ix, xorpixel
    ELSE
    EXTERN  __plot_ADDR
    push    hl
    ld      hl,xorpixel
    ld      (__plot_ADDR),hl
    pop     hl
    ENDIF
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    call    drawbox
  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

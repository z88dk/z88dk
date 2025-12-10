; ----- void __CALLEE__ undrawb(int x, int y, int h, int v)

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  undrawb_callee
    PUBLIC  _undrawb_callee

    PUBLIC  asm_undrawb

    EXTERN  drawbox
    EXTERN  respixel
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


undrawb_callee:
_undrawb_callee:
    pop     af
    pop     bc                          ; height
    pop     de
    ld      b, e                        ; width
    pop     hl                          ; x
    pop     de
    ld      h, e                        ; y
    push    af

asm_undrawb:
    push    ix
    ld      ix, respixel
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    call    drawbox
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF
ENDIF

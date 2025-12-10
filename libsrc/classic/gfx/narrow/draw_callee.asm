; ----- void __CALLEE__ draw(int x, int y, int x2, int y2)


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  draw_callee
    PUBLIC  _draw_callee

    PUBLIC  asm_draw

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  Line
    EXTERN  plotpixel
    INCLUDE "classic/gfx/grafix.inc"


draw_callee:
_draw_callee:
    pop     af                          ; ret addr
    pop     de                          ; y2
    pop     hl
    ld      d, l                        ; x2
    pop     hl                          ; y
    pop     bc
    ld      h, c                        ; x
    push    af                          ; ret addr

asm_draw:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    push    hl
    push    de
    call    plotpixel
    pop     de
    pop     hl
    ld      ix, plotpixel
    call    Line
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

ENDIF

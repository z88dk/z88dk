; ----- void __CALLEE__ drawto(int x2, int y2)

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  drawto_callee
    PUBLIC  _drawto_callee

    PUBLIC  asm_drawto

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  Line
    EXTERN  plotpixel

    EXTERN  __gfx_coords
    INCLUDE "classic/gfx/grafix.inc"


drawto_callee:
_drawto_callee:
    pop     af                          ; ret addr
    pop     de                          ; y2
    pop     hl
    ld      d, l                        ; x2
    push    af                          ; ret addr

asm_drawto:
    ld      hl, (__gfx_coords)
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

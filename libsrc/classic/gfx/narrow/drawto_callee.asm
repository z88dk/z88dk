; ----- void __CALLEE__ drawto(int x2, int y2)

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
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
ELSE
    EXTERN  __plot_ADDR
    ld      hl,plotpixel
    ld      (__plot_ADDR),hl
ENDIF
    ld      hl, (__gfx_coords)
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    push    hl
    push    de
    call    plotpixel
    pop     de
    pop     hl
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      ix, plotpixel
ENDIF
    call    Line
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
ENDIF
    ret
  ENDIF


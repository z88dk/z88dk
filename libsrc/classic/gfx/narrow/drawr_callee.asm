; ----- void __CALLEE__ drawr(int x2, int y2)

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  drawr_callee
    PUBLIC  _drawr_callee

    PUBLIC  asm_drawr

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  Line_r
    EXTERN  plotpixel
    INCLUDE "classic/gfx/grafix.inc"


drawr_callee:
_drawr_callee:
    pop     bc                          ; ret addr
    pop     de                          ; y
    pop     hl                          ; x
    push    bc                          ; ret addr

asm_drawr:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    ld      ix, plotpixel
    call    Line_r
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

ENDIF

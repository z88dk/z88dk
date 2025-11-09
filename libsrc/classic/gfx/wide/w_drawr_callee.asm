; ----- void __CALLEE__ drawr_callee(int x, int y)


IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  drawr_callee
    PUBLIC  _drawr_callee
    PUBLIC  asm_drawr

    EXTERN  __gfx_vram_page_in
    EXTERN  w_line_r
    EXTERN  w_plotpixel
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


drawr_callee:
_drawr_callee:

    pop     af
    pop     de
    pop     hl
    push    af

asm_drawr:
    push    ix
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
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

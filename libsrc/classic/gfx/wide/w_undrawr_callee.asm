; ----- void __CALLEE__ undrawr_callee(int x, int y)


IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  undrawr_callee
    PUBLIC  _undrawr_callee
    PUBLIC  asm_undrawr

    EXTERN  __gfx_vram_page_in
    EXTERN  w_line_r
    EXTERN  w_respixel
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


undrawr_callee:
_undrawr_callee:
    pop     af
    pop     de
    pop     hl
    push    af

asm_undrawr:
    push    ix
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    ld      ix, w_respixel
    call    w_line_r
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF

ENDIF

; ----- void  unplot_callee(int x, int y)


IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  unplot_callee
    PUBLIC  _unplot_callee
    PUBLIC  asm_unplot

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  w_respixel
    INCLUDE "classic/gfx/grafix.inc"


unplot_callee:
_unplot_callee:
    pop     bc
    pop     de                          ; y
    pop     hl                          ; x
    push    bc

asm_unplot:
    push    ix
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    call    w_respixel
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF
ENDIF

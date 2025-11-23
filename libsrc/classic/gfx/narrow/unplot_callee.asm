; ----- void  unplot(int x, int y)


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  unplot_callee
    PUBLIC  _unplot_callee
    PUBLIC  asm_unplot

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  respixel
    INCLUDE "classic/gfx/grafix.inc"


unplot_callee:
_unplot_callee:
    pop     bc                          ; ret addr
    pop     hl                          ; y
    pop     de                          ; x
    ld      h, e
    push    bc                          ; ret addr

asm_unplot:
    push    ix
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    call    respixel
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF
ENDIF

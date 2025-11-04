; ----- void  unplot(int x, int y)


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  unplot_callee
    PUBLIC  _unplot_callee
    PUBLIC  asm_unplot

    EXTERN  swapgfxbk
    EXTERN  __graphics_end

    EXTERN  respixel
    INCLUDE "graphics/grafix.inc"


unplot_callee:
_unplot_callee:
    pop     af                          ; ret addr
    pop     hl                          ; y
    pop     de                          ; x
    ld      h, e
    push    af                          ; ret addr

asm_unplot:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    swapgfxbk
  ENDIF
    call    respixel
  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF
ENDIF

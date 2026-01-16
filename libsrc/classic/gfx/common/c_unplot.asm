;Usage: c_unplot(int x, int h)



    SECTION code_graphics
    PUBLIC  c_unplot
    PUBLIC  _c_unplot
    PUBLIC  ___c_unplot
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  c_respixel
    INCLUDE "classic/gfx/grafix.inc"



c_unplot:
_c_unplot:
___c_unplot:
IF  __CPU_INTEL__|__CPU_GBZ80__
    pop     bc
    pop     hl
    pop     de
    push    de
    push    hl
    push    bc
    ld      h, e
ELSE
    push    ix
    ld      ix, 2
    add     ix, sp
    ld      l, (ix+2)
    ld      h, (ix+4)
ENDIF
IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
ENDIF
    call    c_respixel
IF  _GFX_PAGE_VRAM
    jp      __graphics_end
ELSE
  IF    !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

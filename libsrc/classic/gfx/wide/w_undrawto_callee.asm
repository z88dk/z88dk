; ----- void __CALLEE__ undrawto_callee(int x, int y)


IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  undrawto_callee
    PUBLIC  _undrawto_callee
    PUBLIC  asm_undrawto

    EXTERN  __gfx_vram_page_in
    EXTERN  w_line
    EXTERN  w_respixel
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


undrawto_callee:
_undrawto_callee:
    pop     af
    pop     de
    pop     hl
    push    af

asm_undrawto:
    push    ix
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    ld      ix, w_respixel
    call    w_line
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF

ENDIF

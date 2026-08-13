; ----- void __CALLEE__ undrawto(int x2, int y2)


    SECTION code_graphics

    PUBLIC  undrawto_callee
    PUBLIC  _undrawto_callee
    PUBLIC  asm_undrawto


    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  Line
    EXTERN  respixel

    EXTERN  __gfx_coords
    INCLUDE "classic/gfx/grafix.inc"


undrawto_callee:
_undrawto_callee:
    pop     af                          ; ret addr
    pop     de                          ; y2
    pop     hl
    ld      d, l                        ; x2
    push    af                          ; ret addr

asm_undrawto:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
ELSE
    EXTERN  __plot_ADDR
    ld      hl,respixel
    ld      (__plot_ADDR),hl
ENDIF
    ld      hl, (__gfx_coords)
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    push    hl
    push    de
    call    respixel
    pop     de
    pop     hl
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      ix, respixel
ENDIF
    call    Line
  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
ENDIF
    ret
  ENDIF


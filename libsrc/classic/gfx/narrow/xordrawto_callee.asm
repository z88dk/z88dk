; ----- void __CALLEE__ xordrawto(int x2, int y2)

    SECTION code_graphics

    PUBLIC  xordrawto_callee
    PUBLIC  _xordrawto_callee

    PUBLIC  asm_xordrawto

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  Line
    EXTERN  xorpixel

    EXTERN  __gfx_coords
    INCLUDE "classic/gfx/grafix.inc"


xordrawto_callee:
_xordrawto_callee:
    pop     af                          ; ret addr
    pop     de                          ; y2
    pop     hl
    ld      d, l                        ; x2
    push    af                          ; ret addr

asm_xordrawto:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
ELSE
    EXTERN  __plot_ADDR
    ld      hl,xorpixel
    ld      (__plot_ADDR),hl
ENDIF
    ld      hl, (__gfx_coords)
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    push    hl
    push    de
    call    xorpixel
    pop     de
    pop     hl
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      ix, xorpixel
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


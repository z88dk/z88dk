; ----- void __CALLEE__ xordraw(int x, int y, int x2, int y2)

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  xordraw_callee
    PUBLIC  _xordraw_callee

    PUBLIC  asm_xordraw

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  Line
    EXTERN  xorpixel
    INCLUDE "classic/gfx/grafix.inc"


xordraw_callee:
_xordraw_callee:
    pop     af                          ; ret addr
    pop     de                          ; y2
    pop     hl
    ld      d, l                        ; x2
    pop     hl                          ; y
    pop     bc
    ld      h, c                        ; x
    push    af                          ; ret addr

asm_xordraw:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    push    hl
    push    de
    call    xorpixel
    pop     de
    pop     hl
    ld      ix, xorpixel
    call    Line
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

ENDIF

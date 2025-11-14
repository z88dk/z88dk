; ----- void __CALLEE__ undraw(int x, int y, int x2, int y2)

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  undraw_callee
    PUBLIC  _undraw_callee

    PUBLIC  asm_undraw

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  Line
    EXTERN  respixel
    INCLUDE "classic/gfx/grafix.inc"


undraw_callee:
_undraw_callee:
    pop     af                          ; ret addr
    pop     de                          ; y2
    pop     hl
    ld      d, l                        ; x2
    pop     hl                          ; y
    pop     bc
    ld      h, c                        ; x
    push    af                          ; ret addr

asm_undraw:
    push    ix
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    push    hl
    push    de
    call    respixel
    pop     de
    pop     hl
    ld      ix, respixel
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

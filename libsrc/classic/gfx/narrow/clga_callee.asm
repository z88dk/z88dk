;Usage: clga(int tlx, int tly, int tlx2, int tly2)


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  clga_callee
    PUBLIC  _clga_callee

    PUBLIC  asm_clga

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  cleararea
    INCLUDE "classic/gfx/grafix.inc"


clga_callee:
_clga_callee:
    pop     af                          ; ret addr
    pop     bc                          ; y2
    pop     hl
    ld      b, l                        ; x2
    pop     hl                          ; y
    pop     de
    ld      h, e                        ; x
    push    af                          ; ret addr

asm_clga:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    call    cleararea
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF

ENDIF

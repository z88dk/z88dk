; ----- int point_callee(int x, int y)
;Result is true/false

IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  point_callee
    PUBLIC  _point_callee
    PUBLIC  asm_point

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

    EXTERN  w_pointxy
    INCLUDE "classic/gfx/grafix.inc"


point_callee:
_point_callee:
    pop     bc
    pop     de                          ; y
    pop     hl                          ; x
    push    bc

asm_point:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    call    w_pointxy
  IFDEF _GFX_PAGE_VRAM
    push    af
    call    __gfx_vram_page_out
    pop     af
  ENDIF
    pop     ix
    ld      hl, 1
    ret     nz                          ;pixel set
    dec     hl
    ret
ENDIF


; ----- int point_callee(int x, int y)
;Result is true/false


IF  !__CPU_INTEL__&!__CPU_GBZ80__


    SECTION code_graphics

    PUBLIC  point_callee
    PUBLIC  _point_callee
    PUBLIC  asm_point

    EXTERN  __gfx_page_vram_in
    EXTERN  __gfx_page_vram_out

    EXTERN  pointxy
    INCLUDE "graphics/grafix.inc"


point_callee:
_point_callee:

    pop     bc                          ; ret addr
    pop     hl                          ; y
    pop     de
    ld      h, e                        ; x
    push    bc                          ; ret addr

asm_point:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_page_vram_in
  ENDIF
    call    pointxy

    push    af
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_page_vram_out
  ENDIF
    pop     af
    pop     ix
    ld      hl, 1
    ret     nz                          ;pixel set
    dec     hl
    ret
ENDIF

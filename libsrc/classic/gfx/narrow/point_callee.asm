; ----- int point_callee(int x, int y)
;Result is true/false


    SECTION code_graphics

    PUBLIC  point_callee
    PUBLIC  _point_callee
    PUBLIC  asm_point

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

    EXTERN  pointxy
    INCLUDE "classic/gfx/grafix.inc"


point_callee:
_point_callee:

    pop     bc                          ; ret addr
    pop     hl                          ; y
    pop     de
    ld      h, e                        ; x
    push    bc                          ; ret addr

asm_point:
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
	ENDIF
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    call    pointxy

    push    af
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_out
  ENDIF
    pop     af
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
	ENDIF
    ld      hl, 1
    ret     nz                          ;pixel set
    dec     hl
    ret

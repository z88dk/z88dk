;Usage: c_point(struct *pixel)
;Result is true/false


    SECTION code_graphics
    PUBLIC  c_point
    PUBLIC  _c_point
    PUBLIC  ___c_point

    EXTERN  c_pointxy
    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out
    INCLUDE "classic/gfx/grafix.inc"


c_point:
_c_point:
___c_point:
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
    call    c_pointxy
IFDEF _GFX_PAGE_VRAM
    push    af
    call    __gfx_vram_page_out
    pop     af
ENDIF
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
ENDIF
    ld      hl, 1
    ret     nz                          ;pixel set
    dec     hl
    ret


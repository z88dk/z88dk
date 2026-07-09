;
;     Turtle graphics library
;     Stefano - 11/2017
;
;     $Id: move.asm $
;

    SECTION code_graphics
    PUBLIC  move
    PUBLIC  _move
    PUBLIC  ___move
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  __pen
    EXTERN  Line_r
    EXTERN  plotpixel
    EXTERN  setxy
    INCLUDE "classic/gfx/grafix.inc"


move:
_move:
___move:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
    ld      ix, 2
    add     ix, sp
    ld      e, (ix+2)                   ;py
    ld      d, (ix+3)
    ld      l, (ix+4)                   ;px
    ld      h, (ix+5)
ELSE
    pop     af
    pop     de
    pop     hl
    push    hl
    push    de
ENDIF

  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF

    ld      a, (__pen)
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      ix, setxy
ELSE
    EXTERN  __plot_ADDR
    push    hl
    ld      hl,setxy
    ld      (__plot_ADDR),hl
    pop     hl
ENDIF
    rla
    jr      nc, pen_up
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      ix, plotpixel
ELSE
    EXTERN  __plot_ADDR
    push    hl
    ld      hl,plotpixel
    ld      (__plot_ADDR),hl
    pop     hl
ENDIF
pen_up:

    call    Line_r

  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

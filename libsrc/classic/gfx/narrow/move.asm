;
;     Turtle graphics library
;     Stefano - 11/2017
;
;     $Id: move.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__
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
    push    ix
    ld      ix, 2
    add     ix, sp
    ld      e, (ix+2)                   ;py
    ld      d, (ix+3)
    ld      l, (ix+4)                   ;px
    ld      h, (ix+5)

  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF

    ld      a, (__pen)
    ld      ix, setxy
    rla
    jr      nc, pen_up
    ld      ix, plotpixel
pen_up:

    call    Line_r
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF
ENDIF

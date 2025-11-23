;
;     Z88DK Graphics Functions - Small C+ stubs
;
;     Fill stub - Stefano Bodrato 11/6/2000
;
;
;    $Id: fill.asm,v 1.5 2016-04-13 21:09:09 dom Exp $
;


;Usage: fill(struct *pixel)


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  fill
    PUBLIC  _fill
    PUBLIC  ___fill

    EXTERN  do_fill
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"

fill:
_fill:
___fill:
    push    ix
    ld      ix, 2
    add     ix, sp
    ld      d, (ix+2)                   ;y
    ld      e, (ix+4)                   ;x
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    call    do_fill
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF
ENDIF

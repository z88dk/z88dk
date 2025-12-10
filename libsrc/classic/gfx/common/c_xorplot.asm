;
;      Z88DK Graphics Functions - Small C+ stubs
;
;	$Id: xorplot.asm,v 1.5 2016-04-22 20:17:17 dom Exp $
;

;Usage: xorplot(int x, int y)

    SECTION code_graphics
    PUBLIC  c_xorplot
    PUBLIC  _c_xorplot
    PUBLIC  ___c_xorplot
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  c_xorpixel
    INCLUDE "classic/gfx/grafix.inc"

c_xorplot:
_c_xorplot:
___c_xorplot:
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
    call    c_xorpixel
IF  _gfx_vram_page
    jp      __graphics_end
ELSE
  IF    !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

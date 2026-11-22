; ----- void __CALLEE__ undrawb(int x, int y, int h, int v)
;
;    $Id: drawb_callee.asm $
;

    SECTION code_graphics

    PUBLIC  drawb_callee
    PUBLIC  _drawb_callee

    PUBLIC  asm_drawb

    EXTERN  drawbox
    EXTERN  plotpixel
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


drawb_callee:
_drawb_callee:
    pop     af
    pop     bc                          ; height
    pop     de
    ld      b, e                        ; width
    pop     hl                          ; x
    pop     de
    ld      h, e                        ; y
    push    af

asm_drawb:
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
    ld      ix, plotpixel
	ELSE
    EXTERN  __plot_ADDR
	push    hl
    ld      hl,plotpixel
    ld      (__plot_ADDR),hl
	pop     hl
    ENDIF
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    call    drawbox
  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

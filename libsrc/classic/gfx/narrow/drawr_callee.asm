; ----- void __CALLEE__ drawr(int x2, int y2)

    SECTION code_graphics

    PUBLIC  drawr_callee
    PUBLIC  _drawr_callee

    PUBLIC  asm_drawr

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  Line_r
    EXTERN  plotpixel
    INCLUDE "classic/gfx/grafix.inc"


drawr_callee:
_drawr_callee:
    pop     bc                          ; ret addr
    pop     de                          ; y
    pop     hl                          ; x
    push    bc                          ; ret addr

asm_drawr:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
ELSE
    EXTERN  __plot_ADDR
	push    hl
    ld      hl,plotpixel
    ld      (__plot_ADDR),hl
	pop     hl
ENDIF
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      ix, plotpixel
ENDIF
    call    Line_r
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
ENDIF
    ret
  ENDIF


; ----- void __CALLEE__ xordrawr(int x2, int y2)

    SECTION code_graphics

    PUBLIC  xordrawr_callee
    PUBLIC  _xordrawr_callee

    PUBLIC  asm_xordrawr

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  Line_r
    EXTERN  xorpixel
    INCLUDE "classic/gfx/grafix.inc"


xordrawr_callee:
_xordrawr_callee:
    pop     af                          ; ret addr
    pop     de                          ; y
    pop     hl                          ; x
    push    af                          ; ret addr

asm_xordrawr:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
ELSE
    EXTERN  __plot_ADDR
	push    hl
    ld      hl,xorpixel
    ld      (__plot_ADDR),hl
	pop     hl
ENDIF
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      ix, xorpixel
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


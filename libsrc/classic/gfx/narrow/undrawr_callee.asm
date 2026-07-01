; ----- void __CALLEE__ undrawr_callee(int x2, int y2)


    SECTION code_graphics

    PUBLIC  undrawr_callee
    PUBLIC  _undrawr_callee
    PUBLIC  asm_undrawr

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  Line_r
    EXTERN  respixel
    INCLUDE "classic/gfx/grafix.inc"


undrawr_callee:
_undrawr_callee:
    pop     af                          ; ret addr
    pop     de                          ; y
    pop     hl                          ; x
    push    af                          ; ret addr

asm_undrawr:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
ELSE
    EXTERN  __plot_ADDR
	push    hl
    ld      hl,respixel
    ld      (__plot_ADDR),hl
	pop     hl
ENDIF
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      ix, respixel
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


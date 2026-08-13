;
;     Z88DK Graphics Functions - Small C+ stubs
;
;     Fill stub - Stefano Bodrato 11/6/2000
;
;
;    $Id: fill.asm $
;


;Usage: fill(struct *pixel)


    SECTION code_graphics
    PUBLIC  fill
    PUBLIC  _fill
    PUBLIC  ___fill

    EXTERN  do_fill
    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"

fill:
_fill:
___fill:

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    push    ix
    ld      ix, 2
    add     ix, sp
    ld      d, (ix+2)                   ;y
    ld      e, (ix+4)                   ;x
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF

    call    do_fill

  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

ELSE

  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF

    pop     af                          ; ret addr
    pop     hl
    pop     de                          ; x

    push    de
    push    hl
    ld      d, l                        ; y
    push    af                          ; ret addr

    call    do_fill

  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_out
  ENDIF

    ret

ENDIF

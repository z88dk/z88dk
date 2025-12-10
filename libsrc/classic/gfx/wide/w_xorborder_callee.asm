; ----- void __CALLEE__ xorborder_callee(int x, int y, int x2, int y2)

IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  xorborder_callee
    PUBLIC  _xorborder_callee

    PUBLIC  asm_xorborder

    EXTERN  w_xorpixel
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    INCLUDE "classic/gfx/grafix.inc"


xorborder_callee:
_xorborder_callee:
    pop     af
    pop     de
    pop     hl
    exx                                 ; w_plotpixel and __gfx_vram_page_in must not use the alternate registers, no problem with w_line_r
    pop     de
    pop     hl
    push    af                          ; ret addr
    exx

asm_xorborder:

    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    push    hl
    push    de
    exx
    push    hl
    push    de
    exx

    ;exx
    push    de                          ; y delta
    exx
    pop     bc                          ; y delta

    exx
    push    hl
    ;inc hl
xloop1:
    exx
    call    plot_sub                    ; (hl,de)

    ex      de, hl
    add     hl, bc                      ; y += delta
    ex      de, hl

    inc     hl
    call    plot_sub                    ; (hl,de)

    ex      de, hl
    and     a
    sbc     hl, bc                      ; y -= delta
    ex      de, hl

    inc     hl
    exx
    dec     hl
    ld      a, h
    or      l
    jr      z, endxloop
    dec     hl
    ld      a, h
    or      l
    jr      nz, xloop1
endxloop:

    pop     hl                          ; restore x
    exx


    pop     de                          ; y
    pop     hl
    exx
    pop     de                          ; y delta
    pop     hl
    push    hl                          ; x delta
    exx
    pop     bc                          ; x delta

    ;inc de
    exx
    dec     de
yloop1:
    exx
    call    plot_sub                    ; (hl,de)

    add     hl, bc                      ; x += delta

    inc     de
    call    plot_sub                    ; (hl,de)

    and     a
    sbc     hl, bc                      ; x -= delta

    inc     de
    exx
    dec     de
    ld      a, d
    or      e
    jr      z, endyloop
    dec     de
    ld      a, d
    or      e
    jr      nz, yloop1
endyloop:

  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF




plot_sub:
    push    bc
    push    hl
    push    de
    call    w_xorpixel
    pop     de
    pop     hl
    pop     bc
    ret

ENDIF

;
; Extremely putc implementation for low resolution graphics
; and small memory sizes
;
; Sept 2018 - Stefano
;
; Much More Generic version
; Uses clg, plot and unplot
;
;
; $Id: w_putc4x6.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics


    PUBLIC  putc4x6
    PUBLIC  _putc4x6

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  plot
    EXTERN  unplot
    EXTERN  clg
    EXTERN  l_graphics_cmp
    EXTERN  _font_4x5
    INCLUDE "classic/gfx/grafix.inc"


putc4x6:
_putc4x6:
    ld      hl, 2
    add     hl, sp

    ld      a, (hl)

    cp      12                          ; cls ?
    jr      nz, nocls
    ld      hl, 0
    ld      (x_4x6), hl
    ld      (y_4x6), hl

    jp      clg
nocls:

    cp      10
    jp      z, do_nl
    cp      13
    jp      z, do_nl

    cp      8
    jr      nz, nobs
    ld      hl, (x_4x6)
    ld      de, 4
    sbc     hl, de
    jr      c, nobs1
    ld      (x_4x6), hl
nobs1:
    ld      a, ' '
    call    nolower
    ld      hl, (x_4x6)
    ld      de, 4
    sbc     hl, de
    ld      (x_4x6), hl
    ret

nobs:
    ; cp      97
    ; jr      c, nolower
    ; sub     32                          ; uppercase only
nolower:
    sub     32

    ld      (chr), a

    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    ld      a, (chr)
    rra

    ld      e, a
    add     a
    add     a
    add     e                           ; a=a*5 !

    ld      d, 0
    ld      e, a
    ld      hl, _font_4x5
    add     hl, de

    ld      b, 5
rowloop:
    push    bc
    push    hl
    ld      a, (chr)
    rra                                 ; even odd ?
    ld      a, (hl)
    jr      nc, iseven
    rla
    rla
    rla
    rla
iseven:
    ld      b, 4
    ld      c, a

    ld      de, (x_4x6)
colloop:
    rl      c                           ; cy = pixel status
    push    bc
    push    de
    ld      de, (y_4x6)
    push    de

    jr      nc, noplot
    call    plot
    jr      nores
noplot:
    call    unplot
nores:
    pop     de
    pop     de
    inc     de

    pop     bc
    djnz    colloop

    ld      hl, (y_4x6)
    inc     hl
    ld      (y_4x6), hl

    pop     hl
    inc     hl
    pop     bc
    djnz    rowloop

    ld      b, 4
    ld      de, (x_4x6)
lrloop:
    push    bc
    push    de
    ld      de, (y_4x6)
    push    de
    call    unplot
    pop     de
    pop     de
    ;ld    a,e            ; keep new x position
    inc     de
    pop     bc
    djnz    lrloop

    push    hl
    ld      hl, _GFX_MAXX
    call    l_graphics_cmp
    pop     hl
    call    nc, do_nl

    ld      (x_4x6), de                 ; update x position

    push    hl
    ld      hl, (y_4x6)
    ld      de, 4                       ; 4+1 (CY is set)
    sbc     hl, de
    ld      (y_4x6), hl
    pop     hl

  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF
do_nl:
    push    hl
    ld      hl, (y_4x6)
    ld      de, 6
    add     hl, de
    ld      (y_4x6), hl
    ex      de, hl
    ld      hl, 0
    ld      (x_4x6), hl                 ; update x position
    pop     hl
    ret


    SECTION bss_graphics

    PUBLIC  x_4x6
    PUBLIC  _x_4x6
    PUBLIC  y_4x6
    PUBLIC  _y_4x6

x_4x6:
_x_4x6:
    defw    0

y_4x6:
_y_4x6:
    defw    0

chr:
    defb    0


ENDIF

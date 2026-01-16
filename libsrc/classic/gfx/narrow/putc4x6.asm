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
; $Id: putc4x6.asm $
;

    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_graphics


    PUBLIC  putc4x6
    PUBLIC  _putc4x6

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  plot
    EXTERN  unplot
    EXTERN  clg
    EXTERN  _font_4x5


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
    ld      a, (x_4x6)
    sub     4
    jr      c, nobs1
    ld      (x_4x6), a
nobs1:
    ld      a, ' '
    call    nolower
    ld      a, (x_4x6)
    sub     4
    ld      (x_4x6), a
    ret
nobs:
;     cp      97
;     jr      c, nolower
;     sub     32                          ; uppercase only
nolower:
    sub     32
    ld      (chr), a

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
ENDIF
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

    ld      a, (x_4x6)
    ld      d, 0
    ld      e, a
colloop:
IF  __CPU_INTEL__
    ld      a, c
    rla
    ld      c, a
ELSE
    rl      c                           ; cy = pixel status
ENDIF
    push    bc
    push    de
    ld      a, (y_4x6)
    ld      e, a
    push    de

    jr      nc, noplot
    call    plot
    jr      nores
noplot:
    call    unplot
nores:
    pop     de
    pop     de
    inc     e

    pop     bc
    djnz    colloop

    ld      hl, y_4x6
    inc     (hl)

    pop     hl
    inc     hl
    pop     bc
    djnz    rowloop

    ld      b, 4
    ld      a, (x_4x6)
    ld      d, 0
    ld      e, a
lrloop:
    push    bc
    push    de
    ld      a, (y_4x6)
    ld      e, a
    push    de
    call    unplot
    pop     de
    pop     de
    inc     e
    pop     bc
    djnz    lrloop
    ld      a, e                        ; new x position

IF  _GFX_MAXX<>256
    cp      _GFX_MAXX
    call    nc, do_nl
ELSE
    and     a
    call    z, do_nl
ENDIF

    ld      (x_4x6), a                  ; update x position

    ld      a, (y_4x6)
    sub     5
    ld      (y_4x6), a

IF  _GFX_PAGE_VRAM
    jp      __graphics_end
ELSE
  IF    !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
do_nl:
    ld      a, (y_4x6)
    add     6
    ld      (y_4x6), a
    xor     a
    ld      (x_4x6), a                  ; update x position
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



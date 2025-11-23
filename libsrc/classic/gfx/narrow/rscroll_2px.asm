;
; Scroll 2 pixel left
;
;
; Generic version, Stefano Bodrato - 2025
;
;
; $Id: rscroll_2px.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    PUBLIC  rscroll_2px
    PUBLIC  _rscroll_2px
    PUBLIC  ___rscroll_2px
    EXTERN  pixeladdress
    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

    INCLUDE "classic/gfx/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


rscroll_2px:
_rscroll_2px:
___rscroll_2px:


  IF    _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF

; 2 blank pixel columns on the right
; to avoid the picture to get back in on the left side
    ld      b,_GFX_MAXY
loop2:
    ld      h,_GFX_MAXX-1
    ld      l,b
    dec     l
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0xFC
    ld      (de),a
    djnz    loop2

; get the display memory position and size
    ld      hl,0
    call    pixeladdress
    ld      h,d
    ld      l,e

    ld      bc,_GFX_MAXX*_GFX_MAXY/64

    
; now, the actual scroll
    ld de,0

loop:
    rl  d
    rr (hl)
    rr  d

    rl  e
    rr (hl)
    rr  e

    inc hl
    rl  d
    rr (hl)
    rr  d

    rl  e
    rr (hl)
    rr  e

    inc hl
    rl  d
    rr (hl)
    rr  d

    rl  e
    rr (hl)
    rr  e

    inc hl
    rl  d
    rr (hl)
    rr  d

    rl  e
    rr (hl)
    rr  e

    inc hl
    rl  d
    rr (hl)
    rr  d

    rl  e
    rr (hl)
    rr  e

    inc hl
    rl  d
    rr (hl)
    rr  d

    rl  e
    rr (hl)
    rr  e

    inc hl
    rl  d
    rr (hl)
    rr  d

    rl  e
    rr (hl)
    rr  e

    inc hl
    rl  d
    rr (hl)
    rr  d

    rl  e
    rr (hl)
    rr  e

    inc hl
    dec bc
    ld a,b
    or c
    jr nz,loop

  IF    _gfx_vram_page
    call    __gfx_vram_page_out
  ENDIF
    ret


ENDIF

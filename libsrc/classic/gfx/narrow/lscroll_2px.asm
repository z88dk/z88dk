;
; Scroll 2 pixel left
;
;
; Generic version, Stefano Bodrato - 2025
;
;
; $Id: lscroll_2px.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    PUBLIC  lscroll_2px
    PUBLIC  _lscroll_2px
    PUBLIC  ___lscroll_2px
    EXTERN  pixeladdress
    EXTERN  swapgfxbk
    EXTERN  swapgfxbk1

    INCLUDE "classic/gfx/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


lscroll_2px:
_lscroll_2px:
___lscroll_2px:


  IF    NEED_swapgfxbk
    call    swapgfxbk
  ENDIF

; 2 blank pixel columns on the left
; to avoid the picture to get back in on the right side
    ld      b,maxy
loop2:
    ld      h,0
    ld      l,b
    dec     l
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0x3F
    ld      (de),a
    djnz    loop2

; get the display memory position and size
    ld      h,maxx-1
    ld      l,maxy-1
    call    pixeladdress
    ld      h,d
    ld      l,e

    ld      bc,maxx*maxy/64

    
; now, the actual scroll
    ld de,0

loop:
    rl  d               ; loop unrolling
    rl (hl)
    rr  d

    rl  e
    rl (hl)
    rr  e
    
    dec hl

    rl  d               ; loop unrolling..
    rl (hl)
    rr  d

    rl  e
    rl (hl)
    rr  e
    
    dec hl

    rl  d
    rl (hl)
    rr  d

    rl  e
    rl (hl)
    rr  e
    
    dec hl

    rl  d
    rl (hl)
    rr  d

    rl  e
    rl (hl)
    rr  e
    
    dec hl

    rl  d
    rl (hl)
    rr  d

    rl  e
    rl (hl)
    rr  e
    
    dec hl

    rl  d
    rl (hl)
    rr  d

    rl  e
    rl (hl)
    rr  e
    
    dec hl

    rl  d
    rl (hl)
    rr  d

    rl  e
    rl (hl)
    rr  e
    
    dec hl

    rl  d
    rl (hl)
    rr  d

    rl  e
    rl (hl)
    rr  e

    dec hl
    dec bc
    ld a,b
    or c
    jr nz,loop

  IF    NEED_swapgfxbk
    call    swapgfxbk1
  ENDIF
    ret


ENDIF

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

    INCLUDE "graphics/grafix.inc"

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
    ld      b,maxy-1
loop1:
    ld      h,0
    ld      l,b
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0x3F
    ld      (de),a
    djnz    loop1

; get the display memory position and size
    ld      h,maxx-1
    ld      l,maxy-1
    call    pixeladdress
    push    de
    push    de
    ld      h,0
    ld      l,0
    call    pixeladdress
    pop     hl
    and     a
    sbc     hl,de
    ld      b,h
    ld      c,l
    inc     bc
    rr      b           ; loop unrolling
    rr      c
    and     a
    rr      b
    rr      c
    and     a
    rr      b
    rr      c
    pop     hl
    
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

; 2 blank pixel columns on the right
; to avoid the picture to get back in on the left side
    ld      b,maxy-1
loop2:
    ld      h,maxx-1
    ld      l,b
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0xFC
    ld      (de),a
    djnz    loop2

  IF    NEED_swapgfxbk
    call    swapgfxbk1
  ENDIF
    ret


ENDIF

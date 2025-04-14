;
; Scroll 1 pixel left
;
;
; Generic version, Stefano Bodrato - 2025
;
;
; $Id: lscroll_1px.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    PUBLIC  lscroll_1px
    PUBLIC  _lscroll_1px
    PUBLIC  ___lscroll_1px
    EXTERN  pixeladdress
    EXTERN  swapgfxbk
    EXTERN  swapgfxbk1

    INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


lscroll_1px:
_lscroll_1px:
___lscroll_1px:


  IF    NEED_swapgfxbk
    call    swapgfxbk
  ENDIF

; clear 1 pixel column on the left
    ld      b,maxy-1
loop1:
    ld      h,0
    ld      l,b
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0x7F
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

    sub     a
    push    af    ; CY reset, to be used in the scroll loop


; now, the actual scroll
loop:
    pop af
    rl (hl)           ; loop unrolling
    dec hl
    rl (hl)
    dec hl
    rl (hl)
    dec hl
    rl (hl)

    dec hl

    rl (hl)           ; loop unrolling
    dec hl
    rl (hl)
    dec hl
    rl (hl)
    dec hl
    rl (hl)
    push af

    dec hl
    dec bc
    ld a,b
    or c
    jr nz,loop
    
    pop    af

; clear 1 pixel column on the right
    ld      b,maxy-1
loop2:
    ld      h,maxx-1
    ld      l,b
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0xFE
    ld      (de),a
    djnz    loop2

  IF    NEED_swapgfxbk
    call    swapgfxbk1
  ENDIF
    ret


ENDIF

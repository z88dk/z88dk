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

    INCLUDE "classic/gfx/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


lscroll_1px:
_lscroll_1px:
___lscroll_1px:


  IF    NEED_swapgfxbk
    call    swapgfxbk
  ENDIF

; clear 1 pixel column on the left
    ld      b,maxy
loop2:
    ld      h,0
    ld      l,b
    dec     l
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0x7F
    ld      (de),a
    djnz    loop2

; get the display memory position and size
    ld      h,maxx-1
    ld      l,maxy-1
    call    pixeladdress
    ld      h,d
    ld      l,e

    ld      bc,maxx*maxy/64

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

  IF    NEED_swapgfxbk
    call    swapgfxbk1
  ENDIF
    ret


ENDIF

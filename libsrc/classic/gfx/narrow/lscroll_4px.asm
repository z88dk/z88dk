;
; Scroll 4 pixel left
;
;
; Generic version, Stefano Bodrato - 2025
;
;
; $Id: lscroll_4px.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    PUBLIC  lscroll_4px
    PUBLIC  _lscroll_4px
    PUBLIC  ___lscroll_4px
    EXTERN  pixeladdress
    EXTERN  swapgfxbk
    EXTERN  swapgfxbk1

    INCLUDE "classic/gfx/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


lscroll_4px:
_lscroll_4px:
___lscroll_4px:


  IF    NEED_swapgfxbk
    call    swapgfxbk
  ENDIF

; 4 blank pixel columns on the left
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
    and     0x0F
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
    rld               ; loop unrolling..
    dec hl
    rld
    dec hl
    rld
    dec hl
    rld
    dec hl
    rld
    dec hl
    rld
    dec hl
    rld
    dec hl
    rld
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

;
; Scroll 8 pixel left
;
;
; Generic version, Stefano Bodrato - 2025
;
;
; $Id: lscroll_8px.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    PUBLIC  lscroll_8px
    PUBLIC  _lscroll_8px
    PUBLIC  ___lscroll_8px
    EXTERN  pixeladdress
    EXTERN  swapgfxbk
    EXTERN  swapgfxbk1

    INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


lscroll_8px:
_lscroll_8px:
___lscroll_8px:


  IF    NEED_swapgfxbk
    call    swapgfxbk
  ENDIF

; clear 1 byte column on the left
    ld      b,maxy
loop2:
    ld      h,0
    ld      l,b
    dec     l
    push    bc
    call    pixeladdress
    pop     bc
    xor     a
    ld      (de),a
    djnz    loop2

; get the display memory position and size
    ld      h,a
    ld      l,a
    call    pixeladdress
    ld      h,d
    ld      l,e
    inc     hl

    ld      bc,maxx*maxy/8


; now, the actual scroll
loop:
    ldi         ; loop unrolling
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi

    dec bc
    ld a,b
    or c
    jr z,end_loop
    inc bc

    ldi
    jr loop

end_loop:
    ld (de),a

  IF    NEED_swapgfxbk
    call    swapgfxbk1
  ENDIF
    ret


ENDIF

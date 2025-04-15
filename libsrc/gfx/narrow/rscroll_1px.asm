;
; Scroll 1 pixel left
;
;
; Generic version, Stefano Bodrato - 2025
;
;
; $Id: rscroll_1px.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    PUBLIC  rscroll_1px
    PUBLIC  _rscroll_1px
    PUBLIC  ___rscroll_1px
    EXTERN  pixeladdress
    EXTERN  swapgfxbk
    EXTERN  swapgfxbk1

    INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


rscroll_1px:
_rscroll_1px:
___rscroll_1px:


  IF    NEED_swapgfxbk
    call    swapgfxbk
  ENDIF

; clear 1 pixel column on the right
    ld      b,maxy
loop2:
    ld      h,maxx-1
    ld      l,b
    dec     l
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0xFE
    ld      (de),a
    djnz    loop2

; get the display memory position and size
    ld      h,0
    ld      l,0
    call    pixeladdress
    ld      h,d
    ld      l,e

    ld      bc,maxx*maxy/64

    sub     a
    push    af    ; CY reset, to be used in the scroll loop

; now, the actual scroll
loop:
    pop af
    rr (hl)           ; loop unrolling
    inc hl
    rr (hl)
    inc hl
    rr (hl)
    inc hl
    rr (hl)
    inc hl

    rr (hl)
    inc hl
    rr (hl)
    inc hl
    rr (hl)
    inc hl
    rr (hl)
    push af

    inc hl
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

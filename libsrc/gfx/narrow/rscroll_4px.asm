;
; Scroll 4 pixel left
;
;
; Generic version, Stefano Bodrato - 2025
;
;
; $Id: rscroll_4px.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    PUBLIC  rscroll_4px
    PUBLIC  _rscroll_4px
    PUBLIC  ___rscroll_4px
    EXTERN  pixeladdress
    EXTERN  swapgfxbk
    EXTERN  swapgfxbk1

    INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


rscroll_4px:
_rscroll_4px:
___rscroll_4px:


  IF    NEED_swapgfxbk
    call    swapgfxbk
  ENDIF

; 4 blank pixel columns on the right
; to avoid the picture to get back in on the right side
    ld      b,maxy-1
loop1:
    ld      h,0
    ld      l,b
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0xF0
    ld      (de),a
    djnz    loop1

; get the display memory position and size
    ld      h,0
    ld      l,0
    call    pixeladdress
    push    de
    push    de
    ld      h,maxx-1
    ld      l,maxy-1
    call    pixeladdress
    pop     hl
    and     a
    ex      de,hl
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
    
    xor     a
    push    af    ; CY reset, to be used in the scroll loop

; now, the actual scroll
loop:
    pop af
    rrd               ; loop unrolling..
    inc hl
    rrd
    inc hl
    rrd
    inc hl
    rrd
    inc hl
    rrd
    inc hl
    rrd
    inc hl
    rrd
    inc hl
    rrd
    push af

    inc hl
    dec bc
    ld a,b
    or c
    jr nz,loop
    
    pop    af

; 4 blank pixel columns on the left
; to avoid the picture to get back in on the left side
    ld      b,maxy-1
loop2:
    ld      h,maxx-1
    ld      l,b
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0x0F
    ld      (de),a
    djnz    loop2

  IF    NEED_swapgfxbk
    call    swapgfxbk1
  ENDIF
    ret


ENDIF

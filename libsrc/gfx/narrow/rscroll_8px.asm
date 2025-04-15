;
; Scroll 8 pixel left
;
;
; Generic version, Stefano Bodrato - 2025
;
;
; $Id: rscroll_8px.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    PUBLIC  rscroll_8px
    PUBLIC  _rscroll_8px
    PUBLIC  ___rscroll_8px
    EXTERN  pixeladdress
    EXTERN  swapgfxbk
    EXTERN  swapgfxbk1

    INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


rscroll_8px:
_rscroll_8px:
___rscroll_8px:


  IF    NEED_swapgfxbk
    call    swapgfxbk
  ENDIF

; clear 1 byte column on the right
    ld      b,maxy
loop2:
    ld      h,maxx-1
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
	push    hl
    dec     hl

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
    ldi

    ld a,b
    or c
    jr nz,loop
    
    pop    hl
	ld (hl),0

  IF    NEED_swapgfxbk
    call    swapgfxbk1
  ENDIF
    ret


ENDIF

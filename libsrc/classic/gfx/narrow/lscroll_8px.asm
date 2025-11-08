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
    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

    INCLUDE "classic/gfx/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


lscroll_8px:
_lscroll_8px:
___lscroll_8px:


  IF    _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF

; clear 1 byte column on the left
    ld      b,_GFX_MAXY
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

    ld      bc,_GFX_MAXX*_GFX_MAXY/8


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

  IF    _gfx_vram_page
    call    __gfx_vram_page_out
  ENDIF
    ret


ENDIF

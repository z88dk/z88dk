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
    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

    INCLUDE "classic/gfx/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


rscroll_1px:
_rscroll_1px:
___rscroll_1px:


  IF    _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF

; clear 1 pixel column on the right
    ld      b,_GFX_MAXY
loop2:
    ld      h,_GFX_MAXX-1
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
    ld      hl,0
    call    pixeladdress
    ld      h,d
    ld      l,e

    ld      bc,_GFX_MAXX*_GFX_MAXY/64

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

  IF    _GFX_PAGE_VRAM
    call    __gfx_vram_page_out
  ENDIF
    ret


ENDIF

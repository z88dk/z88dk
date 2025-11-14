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
    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

    INCLUDE "classic/gfx/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


rscroll_4px:
_rscroll_4px:
___rscroll_4px:


  IF    _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF

; 4 blank pixel columns on the right
; to avoid the picture to get back in on the right side
    ld      b,_GFX_MAXY
loop2:
    ld      h,_GFX_MAXX-1
    ld      l,b
    dec     l
    push    bc
    call    pixeladdress
    pop     bc
    ld      a,(de)
    and     0xF0
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


  IF    _gfx_vram_page
    call    __gfx_vram_page_out
  ENDIF
    ret


ENDIF

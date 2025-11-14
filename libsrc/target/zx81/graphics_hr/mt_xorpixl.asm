    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_graphics
    PUBLIC  xorpixel

    EXTERN  pixeladdress
    EXTERN  __gfx_coords

;
; ZX81 - Memotech WRX mode version
;
;    $Id: mt_xorpixl.asm $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the bottom left corner.
;
; in:  hl    = (x,y) coordinate of pixel (h,l)
;
; registers changed    after return:
;  ..bc..../ixiy same
;  af..dehl/.... different
;
; ******************************************************************
;
; XOR added by Stefano Bodrato (Feb 2001)
;
; **************
;

xorpixel:
IF  _GFX_MAXX<>256
    ld      a, h
    cp      _GFX_MAXX
    ret     nc
ENDIF

IF  _GFX_MAXY<>256
    ld      a, l
    cp      _GFX_MAXY
    ret     nc                          ; y0    out of range
ENDIF

    ld      (__gfx_coords), hl

    push    bc
    call    pixeladdress
    ld      b, a
    ld      a, 1
    jr      z, xor_pixel                ; pixel is at bit 0...
plot_position:
    rlca
    djnz    plot_position
xor_pixel:
    ex      de, hl
    xor     (hl)
    cp      0x76
    jr      nz,no_halt
    ld      a,0x56
no_halt:
    ld      (hl), a
    pop     bc
    ret

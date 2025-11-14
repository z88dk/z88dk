;
;	MSX extension for "GFX - a small graphics library" by Jannone
;

    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_video_vdp
    PUBLIC  surface_plotpixel

    EXTERN  surface_pixeladdress
    EXTERN  __gfx_coords

    EXTERN  __graphics_end
    EXTERN  __gfx_vram_page_in

;
;	$Id: surface_plotpixl.asm $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate in current screen buffer.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the top left corner.
;
; in:  hl = (x,y) coordinate of pixel (h,l)
;
; registers changed after return:
;  ..bc..../ixiy same
;  af..dehl/.... different
;
surface_plotpixel:
IF  _GFX_MAXX<>256
    ld      a, h
    cp      _GFX_MAXX
    ret     nc
ENDIF

    ld      a, l
    cp      _GFX_MAXY
    ret     nc                          ; y0	out of range

    ld      (__gfx_coords), hl

    call    __gfx_vram_page_in
    push    ix

    push    bc
    call    surface_pixeladdress
    ld      b, a
    ld      a, 1
    jr      z, or_pixel                 ; pixel is at bit 0...
plot_position:
    rlca
    djnz    plot_position
or_pixel:
    ex      de, hl
    or      (hl)
    ld      (hl), a
    pop     bc
    jp      __graphics_end

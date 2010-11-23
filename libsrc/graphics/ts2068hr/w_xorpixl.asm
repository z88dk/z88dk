        INCLUDE "graphics/grafix.inc"

        XLIB    w_xorpixel

        LIB     l_cmp
        LIB     w_pixeladdress

        XREF    COORDS

;
;       $Id: w_xorpixl.asm,v 1.1 2010-11-23 15:45:33 stefano Exp $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the top left corner.
;
; in:  hl,de    = (x,y) coordinate of pixel
;
; registers changed after return:
;  ......../ixiy same
;  afbcdehl/.... different
;
.w_xorpixel
		ld a,maxy
		cp c
		ret c
		ld a,1
		cp h
		ret c

		ld (COORDS),hl     ; store X
		ld (COORDS+2),de   ; store Y: COORDS must be 2 bytes wider

		call w_pixeladdress
		ld b,a
		ld a,1
		jr z,xor_pixel     ; pixel is at bit 0...
.plot_position
		rlca
		djnz plot_position
.xor_pixel
		ex de,hl
		xor (hl)
		ld (hl),a
		ret


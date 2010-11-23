        INCLUDE "graphics/grafix.inc"

        XLIB    w_respixel

        LIB     w_pixeladdress

        XREF    COORDS

;
;       $Id: w_respixl.asm,v 1.1 2010-11-23 15:45:33 stefano Exp $
;

; ******************************************************************
;
; Reset pixel at (x,y) coordinate.
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
.w_respixel
		ld a,maxy
		cp c
		ret c
		ld a,1
		cp h
		ret c

		ld (COORDS),hl     ; store Y
		ld (COORDS+2),de   ;  store X: COORDS must be 2 bytes wider

		call w_pixeladdress
		ld b,a
		ld a,1
		jr z, reset_pixel
.reset_position
		rlca
		djnz reset_position
.reset_pixel
		ex de,hl
		cpl
		and (hl)
		ld (hl),a
		ret

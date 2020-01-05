        INCLUDE "graphics/grafix.inc"

	SECTION   code_clib
        PUBLIC    w_pointxy

        ;EXTERN     l_cmp
        EXTERN     w_pixeladdress

        EXTERN    __gfx_coords

;
;       $Id: w_pointxy.asm,v 1.6 2016-07-02 09:01:35 dom Exp $
;

; ******************************************************************
;
; Get pixel at (x,y) coordinate.
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the top left corner.
;
; in:  hl,de = (x,y) coordinate of pixel to test
;
; registers changed after return:
;  ......../ixiy same
;  afbcdehl/.... different
;
.w_pointxy

        ;push    hl
        ;ld      hl,maxy
        ;call    l_cmp
        ;pop     hl
        ;ret     nc               ; Return if Y overflows

        ;push    de
        ;ld      de,maxx
        ;call    l_cmp
        ;pop     de
        ;ret     c                ; Return if X overflows
        
	call	w_pixeladdress

	ld	b,a
	ld	a,1
	jr	z, test_pixel		; pixel is at bit 0...
.pix_position
	rlca
	djnz	pix_position
.test_pixel

	ex	af,af
	ld	d,18
        ld      bc,0d600h
        out     (c),d
loop1:
        in      a,(c)
        rla
        jp      nc,loop1
        inc	c
        out     (c),h

        dec	c
        inc	d
        out     (c),d
loop2:
        in      a,(c)
        rla
        jp      nc,loop2
        inc	c
        out     (c),l

        dec	c
        ld	a,31
        out     (c),a
loop3:
        in      a,(c)
        rla
        jp      nc,loop3
        inc	c

	ex	af,af
        in	e,(c)
        
        and	e
        
        ret

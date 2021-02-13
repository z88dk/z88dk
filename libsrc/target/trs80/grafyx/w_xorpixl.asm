;
;       Micro-Labs Grafyx Solution Hi-Rez graphics routines for TRS-80
;
;       Stefano Bodrato 2021
;

        INCLUDE "graphics/grafix.inc"

	SECTION   code_clib
        PUBLIC    w_xorpixel

        EXTERN     l_cmp
        ;EXTERN     w_pixeladdress

        EXTERN    __gfx_coords

;
;       $Id: w_xorpixl.asm $
;

; ******************************************************************
;
; XOR pixel at (x,y) coordinate.
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
        push    hl
        ld      hl,maxy
        call    l_cmp
        pop     hl
        ret     nc               ; Return if Y overflows

        push    de
        ld      de,maxx
        call    l_cmp
        pop     de
        ret     c                ; Return if X overflows
        
        ld      (__gfx_coords),hl      ; store X
        ld      (__gfx_coords+2),de    ; store Y: COORDS must be 2 bytes wider

		ld		bc,128

		ld		a,l
		
        srl     h               ;hl = x / 8
        rr      l
        srl     h
        rr      l
        srl     h
        rr      l
		
		out		(c),l			; set X byte coordinate
		inc     bc
		out		(c),e			; set Y byte coordinate

        and     7               ;a = x mod 8
        xor     7

	;call	w_pixeladdress

	ld	d,a
	ld	a,1
	jr	z, or_pixel		; pixel is at bit 0...
.plot_position
	rlca
	dec d
	jr	nz,plot_position
.or_pixel

		inc	bc	; 130
        in	e,(c)

        xor	e	; set pixel in current byte

        out	(c),a
        
	ret
  

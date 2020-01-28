
        INCLUDE "graphics/grafix.inc"

        SECTION code_clib
		
        PUBLIC    w_plotpixel
		PUBLIC    w_pixel

        EXTERN     l_graphics_cmp

        EXTERN    __gfx_coords
        EXTERN    subcpu_call


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

.w_plotpixel
			ld	a,2
.w_pixel
			ld	(mode),a
			
			push    hl
			ld      hl,maxy
			call    l_graphics_cmp
			pop     hl
			ret     nc               ; Return if Y overflows

			push    de
			ld      de,maxx
			call    l_graphics_cmp
			pop     de
			ret     c               ; Return if X overflows
			
			ld      (__gfx_coords),hl     ; store X
			ld      (__gfx_coords+2),de   ; store Y: COORDS must be 2 bytes wider
			
			ld	bc,xcoord
			ld	a,h
			ld	(bc),a		; X (MSB)
			inc	bc
			ld	a,l
			ld	(bc),a		; X (LSB)
			inc	bc
			ld	a,e
			ld	(bc),a		; Y
			
			ld	hl,packet
			jp	subcpu_call


	SECTION	data_clib

packet:
	defw	sndpkt
	defw	5		; packet sz
	defw	xcoord	; packet addr expected back from the slave CPU (useless)
	defw	1		; size of the expected packet being received ('bytes'+1)

						
sndpkt:
	defb	$27		; slave CPU command to paint a pixel
xcoord:
	defb	0		; MSB
	defb	0		; LSB
ycoord:
	defb	0
mode:
	defb	2		; 0:res, 2:plot, 3:xor



        INCLUDE "graphics/grafix.inc"

        SECTION code_clib
		
        PUBLIC    w_pointxy

        EXTERN     l_graphics_cmp

        ;EXTERN    __gfx_coords
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

.w_pointxy
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
			
;			ld      (__gfx_coords),hl     ; store X
;			ld      (__gfx_coords+2),de   ; store Y: COORDS must be 2 bytes wider
			
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
			call	subcpu_call
			ld	a,(data)
			and	a
			ret


	SECTION	data_clib

packet:
	defw	sndpkt
	defw	4		; packet sz
	defw	rcvpkt	; packet addr expected back from the slave CPU (useless)
	defw	2		; size of the expected packet being received

						
sndpkt:
	defb	$28		; slave CPU command to read a pixel
xcoord:				; (also used for return code)
	defb	0		; x MSB / return code
	defb	0		; x LSB / bit test result
ycoord:
	defb	0

rcvpkt:
	defb 0
data:
	defb 0


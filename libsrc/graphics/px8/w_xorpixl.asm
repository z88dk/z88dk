        INCLUDE "graphics/grafix.inc"

        SECTION code_clib
        PUBLIC    w_xorpixel

        EXTERN     l_graphics_cmp
		EXTERN     subcpu_call

        EXTERN    __gfx_coords


; ******************************************************************
;
; Xor pixel at (x,y) coordinate.
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the top left corner.
;
; in:  hl,de    = (x,y) coordinate of pixel
;

.w_xorpixel
				push hl
				ld   hl,maxy
				call l_graphics_cmp
				pop  hl
				ret  nc               ; Return if Y overflows

				push de
				ld   de,maxx
				call l_graphics_cmp
				pop  de
				ret  c               ; Return if X overflows
				
				ld   (__gfx_coords),hl     ; store X
				ld   (__gfx_coords+2),de   ; store Y: COORDS must be 2 bytes wider

				ld   a,e
				ld   (ycoord),a
				
				ld   a,l
				and  7             ;a = x mod 8
				ld   b,a
						
				srl  h               ;hl = x / 8
				rr   l
				srl  h
				rr   l
				srl  h
				rr   l
				
				ld   a,l
				ld   (xcoord),a
				
				xor  a
				scf
				inc b
.pixelpos
				rra
				djnz pixelpos
				
				ld   (data),a
				
				ld   hl,packet_wr
				jp   subcpu_call


		SECTION	data_clib

; master packet for write operation
packet_wr:
	defw	sndpkt
packet_sz:
	defw	7		; packet sz (=6+data len)
	defw	xcoord	; packet addr expected back from the slave CPU (1 byte for return code only, we use the foo position of xcoord)
	defw	1		; size of the expected packet being received (just the return code)

	
sndpkt:
	defb	$25		; slave CPU command to write to the graphics memory ($25 = write)
xcoord:
	defb	0
ycoord:
	defb	0
width:
	defb	1
height:
	defb	1
operation:
	defb	3		; XOR
data:
	defb	0



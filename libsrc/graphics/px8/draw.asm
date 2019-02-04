;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       PX8 variant by Stefano Bodrato
;
;
;


		SECTION         code_clib
		
		PUBLIC    draw
		PUBLIC	  _draw
		
		PUBLIC    do_draw
		
        EXTERN    subcpu_call
		EXTERN    __gfx_coords

.draw
._draw
		ld		a,2
.do_draw
		ld		(draw_mode),a
		pop		af
		ex		af,af
		
		ld		b,4
		ld		de,y1coord+1
.bcount
		pop		hl
		ld		a,l
		ld		(de),a
		dec		de
		ld		a,h
		ld		(de),a
		dec		de
		djnz	bcount
		push	bc
		push	bc
		push	bc
		push	bc
		
		ex		af,af
		push	af

		
		ld	hl,packet
		jp	subcpu_call


	SECTION	data_clib

packet:
	defw	sndpkt
	defw	12		; packet sz
	defw	x0coord	; packet addr expected back from the slave CPU (useless)
	defw	1		; size of the expected packet being received ('bytes'+1)


sndpkt:
	defb	$29		; slave CPU command to draw a line
x0coord:
	defb	0		; MSB
	defb	0		; LSB
y0coord:
	defb	0		; MSB
	defb	0		; LSB
x1coord:
	defb	0		; MSB
	defb	0		; LSB
y1coord:
	defb	0		; MSB
	defb	0		; LSB
oper:
	defb	255		; draw operation mask (used for dotted lines
	defb	255
draw_mode:
	defb	3		; 0:res, 2:plot, 3:xor



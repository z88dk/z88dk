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
		PUBLIC    do_drawr
		
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

.go_subcpu
		ld		hl,(x1coord)
		ld		a,h	; swap MSB<>LSB
		ld		h,l
		ld		l,a
		ld      (__gfx_coords),hl     ; store X
		ld		hl,(y1coord)
		ld		a,h	; swap MSB<>LSB
		ld		h,l
		ld		l,a
		ld      (__gfx_coords+2),hl   ; store Y: COORDS must be 2 bytes wider
		
		ld	hl,packet
		jp	subcpu_call



.do_drawr
		ld		(draw_mode),a
		
		push	hl		; save X delta
		
		ld		hl,(__gfx_coords+2)
		ld		a,h	; swap MSB<>LSB
		ld		h,l
		ld		l,a
		ld      (y0coord),hl     ; store Y
		ld		a,h	; swap MSB<>LSB
		ld		h,l
		ld		l,a
		add		hl,de	; add Y delta (sub if negative)
		ld		a,h	; swap MSB<>LSB
		ld		h,l
		ld		l,a
		ld		(y1coord),hl
		
		pop		de
		ld		hl,(__gfx_coords)
		ld		a,h	; swap MSB<>LSB
		ld		h,l
		ld		l,a
		ld      (x0coord),hl     ; store X
		ld		a,h	; swap MSB<>LSB
		ld		h,l
		ld		l,a
		add		hl,de	; add X delta (sub if negative)
		ld		a,h	; swap MSB<>LSB
		ld		h,l
		ld		l,a
		ld      (x1coord),hl
		jr		go_subcpu


		

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
	defb	3		; 1:res, 2:plot, 3:xor



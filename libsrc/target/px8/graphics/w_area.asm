;
;	z88dk GFX library for the PX8
;
;	Filled rectangle sub
;	
;	Stefano Bodrato, 2019
;
;

	SECTION code_graphics
	PUBLIC	w_area


	EXTERN    subcpu_call

;	
;	$Id: w_area.asm $
;


; IN:  HL,DE = (x,y)
;      HL' = width, DE' = height
;      A = mode (1:res, 2:plot, 3:xor)

.w_area

		ld	(draw_mode),a

		exx
		push	de	;  keep Y
		
		ld	a,e		; Y0, Y1
		ld	(y0coord+1),a
		ld	(y1coord+1),a
		
		push hl		; X0
		ld	a,h
		ld	h,l
		ld	l,a
		ld	(x0coord),hl
		
		exx
		pop bc		; X1 = X0 + width
		dec	hl
		add	hl,bc
		ld	a,h
		ld	h,l
		ld	l,a
		ld	(x1coord),hl
		

		; on stack we now have only the Y coordinate
		; Y size (counter) is on E
		ld	b,e

.yloop
		push	bc
		
		ld	hl,packet
		call subcpu_call

		pop	bc

		pop	hl  ; restore Y coordinate for yloop
		inc	l
		ld	a,l
		ld	(y0coord+1),a
		ld	(y1coord+1),a
		push hl
		
		djnz yloop
		
		pop hl	; balance stack (Y coordinate)
		
		ret
			
			




	SECTION	data_clib


packet:
	defw	sndpkt
	defw	12		; packet sz
	defw	result	; packet addr expected back from the slave CPU (useless)
	defw	1		; size of the expected packet being received ('bytes'+1)

result:
	defb	0

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
	defb	255		; draw operation mask (used for dotted lines)
	defb	255
draw_mode:
	defb	2		; 1:res, 2:plot, 3:xor

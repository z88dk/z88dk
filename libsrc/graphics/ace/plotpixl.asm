
	XLIB	plotpixel

	LIB pixeladdress
	XREF	COORDS

;
;	$Id: plotpixl.asm,v 1.2 2001-04-18 13:21:38 stefano Exp $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; Jupiter ACE version.  
; Emulated 96x64 resolution (TI82/TI83) with 64x48 dots.
;
; (x=x*2/3;  y=y*3/4)
;
;
.plotpixel			
				ld	a,h
				cp	96
				ret	nc
				ld	a,l
				;cp	maxy
				cp	64
				ret	nc		; y0	out of range
				
				ld	(COORDS),hl
				
				push	bc

				add	a,l	; y=y*3/4
				add	a,l
				srl	a
				srl	a
				ld	c,a

				ld	b,0	; x=x*2/3
				sll	h
				ld	a,h
.subtract
				inc	b
				sub	3
				jr	nc,subtract
				dec	b

				push	bc
				
				srl	b
				srl	c
				ld	hl,$2400
;				inc	hl
				ld	a,c
				ld	c,b	; !!
				and	a
				jr	z,r_zero
				ld	b,a
				ld	de,32
.r_loop
				add	hl,de
				djnz	r_loop
.r_zero						; hl = char address
				ld	e,c
				add	hl,de
				
				ld	a,(hl)		; get current symbol
;				dec	a
;				dec	a
				cp	8
				jr	c,islow		; recode graph symbol to binary -> 0..F
				cp	128
				jr	c,ischar
				ld	a,143
				;ld	a,128+10
				sub	(hl)
				;xor	a;;;;
				jr	islow
.ischar
				xor	a		; .. force to blank sym
.islow
				ex	(sp),hl		; save char address <=> restore x,y

				ld	b,a
				ld	a,1		; the bit we want to draw
				
				bit	0,h
				jr	nz,iseven
				add	a,a		; move right the bit

.iseven
				bit	0,l
				jr	z,evenrow
				add	a,a
				add	a,a		; move down the bit
.evenrow
				or	b

;				inc	a
;				inc	a
				cp	8		; Now back from binary to
				jr	c,losym		; graph symbols.

				ld	b,a
				ld	a,15
				sub	b
				add	a,128

;				ld	b,a
;				ld	a,128+10
;				sub	b

.losym

				pop	hl
				ld	(hl),a
				
				pop	bc
				ret

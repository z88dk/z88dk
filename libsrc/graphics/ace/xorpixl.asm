
	XLIB	xorpixel

	XREF	coords

;
;	$Id: xorpixl.asm,v 1.5 2014-05-22 14:55:51 stefano Exp $
;

; ******************************************************************
;
; Invert pixel at (x,y) coordinate.
;
; Jupiter ACE version.  
; 64x48 dots.
;
;
.xorpixel
				ld	a,h
				cp	64
				ret	nc
				ld	a,l
				;cp	maxy
				cp	48
				ret	nc		; y0	out of range
				
				ld	(coords),hl
				
				push	bc

				ld	c,l
				ld	b,h

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
				xor	b

				cp	8		; Now back from binary to
				jr	c,losym		; graph symbols.

				ld	b,a
				ld	a,15
				sub	b
				add	a,128
.losym
				pop	hl
				ld	(hl),a
				
				pop	bc
				ret

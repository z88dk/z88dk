        SECTION code_clib
	PUBLIC	pointxy

	EXTERN	__gfx_coords

;
;	$Id: pointxy.asm,v 1.6 2016-07-02 09:01:36 dom Exp $
;

; ******************************************************************
;
; Get pixel at (x,y) coordinate.
;
; ZX 81 version.  
; 64x48 dots.
;
;
.pointxy
				ld	a,h
				cp	64
				ret	nc
				ld	a,l
				;cp	maxy
				cp	48
				ret	nc		; y0	out of range
				
				ld	(__gfx_coords),hl
				
			push	bc
			push	de
			push	hl			

				ld	c,l
				ld	b,h

				;push	bc
				
				srl	b
				srl	c
IF FORlambda
				ld	hl,16510
ELSE
				ld	hl,(16396)	; D_FILE
				inc	hl
ENDIF
				ld	a,c
				ld	c,b	; !!
				ld	de,33	; 32+1. Every text line ends with an HALT
				and	a
				jr	z,r_zero
				ld	b,a
.r_loop
				add	hl,de
				djnz	r_loop
.r_zero						; hl = char address
				ld	e,c
				add	hl,de
				
				ld	a,(hl)		; get current symbol
				
				cp	8
				jr	c,islow		; recode graph symbol to binary -> 0..F
				ld	a,143
				sub	(hl)

.islow			ex	(sp),hl		; save char address <=> restore x,y

				cp	16		; Just to be sure:
				jr	c,issym		; if it isn't a symbol...
				xor	a		; .. force to blank sym
.issym
				ld	b,a

				ld	a,1		; the bit we want to draw
				
				bit	0,h
				jr	z,iseven
				add	a,a		; move right the bit

.iseven
				bit	0,l
				jr	z,evenrow
				add	a,a
				add	a,a		; move down the bit
.evenrow
				and	b
				
			pop	hl
			pop	de
			pop	bc
				ret

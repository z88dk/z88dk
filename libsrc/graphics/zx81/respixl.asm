        SECTION code_clib
	PUBLIC	respixel

	EXTERN	__gfx_coords

;
;	$Id: respixl.asm,v 1.10 2016-07-02 09:01:36 dom Exp $
;

; ******************************************************************
;
; Clears pixel at (x,y) coordinate.
;
; ZX 81 version.
; 64x48 dots.
;
;
.respixel
				ld	a,h
				cp	64
				ret	nc
				ld	a,l
				;cp	maxy
				cp	48
				ret	nc		; y0	out of range
				
				ld	(__gfx_coords),hl
				
				push	bc

				ld	c,l
				ld	b,h

				push	bc
				
				srl	b
				srl	c
IF FORlambda
				ld	hl,16510
ELSE
				ld	hl,(16396)	; D_FILE
				inc	hl
ENDIF
				;ld	a,b
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
.islow				ex	(sp),hl		; save char address <=> restore x,y

				cp	16		; Just to be sure:
				jr	c,issym		; if it isn't a symbol...
				xor	a		; .. force to blank sym
.issym
				ld	b,a

				ld	a,1		; the bit we want to clear
				
				bit	0,h
				jr	z,iseven
				add	a,a		; move right the bit

.iseven
				bit	0,l
				jr	z,evenrow
				add	a,a
				add	a,a		; move down the bit
.evenrow
				cpl
				and	b

				cp	8		; Now back from binary to
				jr	c,hisym		; graph symbols.
				ld	b,a
				ld	a,15
				sub	b
				add	a,128
.hisym
				pop	hl
				ld	(hl),a
				
				pop	bc
				ret

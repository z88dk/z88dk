;
;       Generic pseudo graphics routines for text-only platforms
;       Version for 1x3 graphics symbols on Heath/Zenith H19
;
;       Written by Stefano Bodrato 2023
;
;
;       Plot pixel at (x,y) coordinate.
;
;
;	$Id: plotpixl.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION	code_clib

			PUBLIC	plotpixel

			EXTERN	textpixl
			EXTERN	div3_0
			EXTERN	__gfx_coords
			EXTERN	h19_backbuffer
			EXTERN	h19_sendchar

.plotpixel
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range
			inc	a
			
			ld	(__gfx_coords),hl
			inc h
			
			push	bc

			ld	c,a	; y
			ld	b,h	; x
			
			push	bc
			
			ld	hl,div3_0
			ld	d,0
			ld	e,c
			adc	hl,de
			ld	a,(hl)
			ld	c,a	; y/3
			
			ld  l,27			; ESC
			call h19_sendchar
			ld  l,'Y'			; "set cursor position"
			call h19_sendchar

			ld	hl,h19_backbuffer
			ld	a,c
			ld	c,b	; !!
			
			and	a
			
			ld	de,maxx
			sbc	hl,de

			jr	z,r_zero
			ld	b,a
			
.r_loop			
			add	hl,de
			djnz	r_loop

.r_zero						; hl = char address
			ld	b,a		; keep y/3
			
			add 31
			push hl
			ld l,a          ; cursor Y position (line)
			call h19_sendchar
			ld a,c
			add 31
			ld l,a          ; cursor X position (column)
			call h19_sendchar
			pop hl

			ld	e,c
			add	hl,de

			ld	a,(hl)		; get current symbol from screen


			ex	(sp),hl		; save char address <=> restore x,y  (y=h, x=l)
			
			ld	c,a		; keep the symbol
			
			ld	a,l
			inc	a
			inc	a
			sub	b
			sub	b
			sub	b		; we get the remainder of y/3
			
			ld	l,a
			ld	a,1		; the pixel we want to draw
			jr	z,iszero
.shifta
			add	a,a
			dec l
			jr nz,shifta
.iszero


			or	c          ; <<<<<---------- "plot"


			pop	hl
			ld	(hl),a     ; update the backbuffer

			ld	hl,textpixl   ; now map pixels to graphics symbol + inversion attr
			ld	d,0
			ld	e,a
			add	hl,de
			ld	a,(hl)
			
			ld  l,27			; ESC
			call h19_sendchar
			ld  l,'F'			; "enter graphics mode"
			call h19_sendchar

			ld  l,27
			call h19_sendchar
			ld  l,'q'	; "cancel reverse video"

			ld h,a
			and 128
			ld a,h
			jr z,noinv
			dec l		; "set reverse video"
.noinv
			call h19_sendchar
			and 127     ; mask out "reverse video" bit

			ld  l,a		; the graphics symbol
			call h19_sendchar

			ld  l,27			; ESC
			call h19_sendchar
			ld  l,'G'			; "exit graphics mode"
			call h19_sendchar
			
			pop	bc
			ret

;
;	z88dk GFX library
;
;	Render the "stencil".
;	The dithered horizontal lines base their pattern on the Y coordinate
;	and on an 'intensity' parameter (0..11).
;	Basic concept by Rafael de Oliveira Jannone
;	
;	Machine code version by Stefano Bodrato, 22/4/2009
;
;	stencil_render(unsigned char *stencil, unsigned char intensity)
;

	INCLUDE	"graphics/grafix.inc"

	XLIB	stencil_render
	LIB	dither_pattern
	;LIB	l_cmp

	;LIB swapgfxbk
	LIB w_pixeladdress
	LIB leftbitmask, rightbitmask
	;XREF swapgfxbk1

;	
;	$Id: w_stencil_render.asm,v 1.1 2010-12-24 11:59:35 stefano Exp $
;

.stencil_render
		ld	ix,2
		add	ix,sp

		;call	swapgfxbk

		ld	bc,maxy
		push	bc
.yloop		pop	bc
		dec	bc
		ld	a,b
		and	c
		cp 255
		;jp	z,swapgfxbk1
		ret	z
		push	bc
		
		ld	d,b
		ld	e,c

		ld	l,(ix+2)	; stencil
		ld	h,(ix+3)

		;push hl
		add	hl,bc
		add	hl,bc
;;;		ld	a,(hl)		;X1
		ld	e,(hl)
		inc hl
		ld	d,(hl)
		dec hl
		;ex	(sp),hl

		ld	a,d			; check left side for current Y position..
		and	e
		cp	127
		jr	z,yloop		; ...loop if nothing to be drawn
		
		ld	bc,maxy*2
		add	hl,bc
		ld	a,(hl)
		inc hl
		ld	h,(hl)
		ld	l,a
		;ex	(sp),hl		;X2 <-> X1

;		cp	(hl)		; if x1>x2, return
;		jr	nc,yloop

		;call	l_cmp	; [carry set if DE < HL]
		pop bc
		push bc

		push hl
		
		;			; C still holds Y
		;push	af		; X1
		;ld	a,(hl)
		;ld	b,a		; X2
		
		ld	a,(ix+0)	; intensity
		push de		; X1
		call	dither_pattern
		pop hl		; X1
		ld	(pattern1+1),a
		ld	(pattern2+1),a

		;	pop	af
		;	ld	h,a	; X1
		;	ld	l,c	; Y
			
			push	bc
			ld	d,b
			ld	e,c
			call	w_pixeladdress		; bitpos0 = pixeladdress(x,y)
			call	leftbitmask		; LeftBitMask(bitpos0)
			pop	bc
			
			ld	h,d
			ld	l,e
			call	mask_pattern
			ex	(sp),hl	; X2 <-> adr0
			push	af	; mask
			;ld	(hl),a
			
			;ld	h,b		; X2
			;ld	l,c		; Y
			
			ld	d,b
			ld	e,c

			call	w_pixeladdress		; bitpos1 = pixeladdress(x+width-1,y)
			call	rightbitmask		; RightBitMask(bitpos1)
			ld	(bitmaskr+1),a		; bitmask1 = LeftBitMask(bitpos0)

			pop	af	; pattern to be drawn (left-masked)
			pop	hl	; adr0
			push	hl
			ex	de,hl
			and	a
			sbc	hl,de

			jr	z,onebyte	; area is within the same address...

			ld	b,l		; number of full bytes in a row
			pop	hl
			
			;ld	de,8

			ld	(hl),a			; (offset) = (offset) AND bitmask0

			;add	hl,de

			;inc	hl			; offset += 1 (8 bits)
         ex     af,af
         ld     a,h
         xor    @00100000
         cp     h
         ld     h,a
         jp     nc,gonehi
         inc	hl
.gonehi
         ex     af,af

.pattern2			ld	a,0
				dec	b
				jr	z,bitmaskr

.fill_row_loop							; do
				ld	(hl),a			; (offset) = pattern
				;add	hl,de
				;inc	hl			; offset += 1 (8 bits)
         ex     af,af
			 ld     a,h
			 xor    @00100000
			 cp     h
			 ld     h,a
			 jp     nc,gonehi2
			 inc	hl
.gonehi2
         ex     af,af
				djnz	fill_row_loop		; while ( r-- != 0 )


.bitmaskr		ld	a,0
			call	mask_pattern
			ld	(hl),a

			jp	yloop


.onebyte	pop	hl
		ld	(pattern1+1),a
		jr	bitmaskr


		; Prepare an edge byte, basing on the byte mask in A
		; and on the pattern being set in (pattern1+1)
.mask_pattern
		ld	d,a		; keep a copy of mask
		and	(hl)		; mask data on screen
		ld	e,a		; save masked data
		ld	a,d		; retrieve mask
		cpl			; invert it
.pattern1	and	0		; prepare fill pattern portion
		or	e		; mix with masked data
		ret

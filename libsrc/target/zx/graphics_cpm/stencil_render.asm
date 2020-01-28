;
;	z88dk GFX library
;
;	Render the "stencil".
;	The dithered horizontal lines base their pattern on the Y coordinate
;	and on an 'intensity' parameter (0..11).
;	Basic concept by Rafael de Oliveira Jannone
;	
;	Machine code version by Stefano Bodrato, 22/4/2009
;	Spectrum +3 CP/M variant by Stefano Bodrato, 2016
;
;	stencil_render(unsigned char *stencil, unsigned char intensity)
;

	INCLUDE	"graphics/grafix.inc"

        SECTION code_clib
	PUBLIC	stencil_render
	PUBLIC	_stencil_render
	EXTERN	dither_pattern

	EXTERN swapgfxbk
	EXTERN pixeladdress
	EXTERN leftbitmask, rightbitmask
	EXTERN swapgfxbk1
	EXTERN __graphics_end

	EXTERN	p3_poke
	EXTERN	p3_peek

;	
;	$Id: stencil_render.asm,v 1.1 2016-10-26 13:03:31 stefano Exp $
;

.stencil_render
._stencil_render
		push	ix
		ld	ix,4
		add	ix,sp

		call	swapgfxbk
		ld	bc,__graphics_end
		push bc

		ld	c,maxy
		push	bc
.yloop		pop	bc
		dec	c
		;jp	z,swapgfxbk1
		ret	z
		push	bc
		
		ld	d,0
		ld	e,c

		ld	l,(ix+2)	; stencil
		ld	h,(ix+3)
		add	hl,de
		ld	a,(hl)		;X1
		
		ld	e,maxy
		add	hl,de
		cp	(hl)		; if x1>x2, return
		jr	nc,yloop
		
					; C still holds Y
		push	af		; X1
		ld	a,(hl)
		ld	b,a		; X2
		
		ld	a,(ix+0)	; intensity
		call	dither_pattern
		ld	(pattern1+1),a
		ld	(pattern2+1),a

			pop	af
			ld	h,a	; X1
			ld	l,c	; Y
			
			push	bc
			call	pixeladdress		; bitpos0 = pixeladdress(x,y)
			call	leftbitmask		; LeftBitMask(bitpos0)
			pop	bc
			push	de			
			
			ld	h,d
			ld	l,e

			call	mask_pattern
			push	af
			;ld	(hl),a
			
			ld	h,b		; X2
			ld	l,c		; Y

			call	pixeladdress		; bitpos1 = pixeladdress(x+width-1,y)
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

;			ld	(hl),a			; (offset) = (offset) AND bitmask0
			push bc
			call p3_poke
			pop bc

			;add	hl,de
			inc	hl			; offset += 1 (8 bits)

.pattern2			ld	a,0
				dec	b
				jr	z,bitmaskr

.fill_row_loop							; do
;				ld	(hl),a			; (offset) = pattern
				push af
				push bc
				call p3_poke
				pop bc
				pop af
				;add	hl,de
				inc	hl			; offset += 1 (8 bits)
				djnz	fill_row_loop		; while ( r-- != 0 )


.bitmaskr		ld	a,0
			call	mask_pattern
			;ld	(hl),a
				push bc
				call p3_poke
				pop bc

			jr	yloop


.onebyte	pop	hl
		ld	(pattern1+1),a
		jr	bitmaskr


		; Prepare an edge byte, basing on the byte mask in A
		; and on the pattern being set in (pattern1+1)
.mask_pattern
		ld	d,a		; keep a copy of mask
			ld e,a
			;and	(hl)		; mask data on screen
			push bc
			call p3_peek
			pop bc
			and e
		ld	e,a		; save masked data
		ld	a,d		; retrieve mask
		cpl			; invert it
.pattern1	and	0		; prepare fill pattern portion
		or	e		; mix with masked data
		ret

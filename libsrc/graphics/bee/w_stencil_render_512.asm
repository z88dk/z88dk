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
;
;	MicroBEE high resolution version, 512x256 dots variant (2016)
;
;
; $Id: w_stencil_render_512.asm,v 1.1 2016-11-25 14:45:01 stefano Exp $
;
;

	INCLUDE	"graphics/grafix.inc"

	SECTION code_clib
	PUBLIC	stencil_render
	PUBLIC	_stencil_render
	EXTERN	dither_pattern
	;EXTERN	l_cmp

	;EXTERN swapgfxbk
	EXTERN w_pixeladdress
	EXTERN leftbitmask, rightbitmask
	;EXTERN swapgfxbk1

;	
;	$Id: w_stencil_render_512.asm,v 1.1 2016-11-25 14:45:01 stefano Exp $
;

.stencil_render_exit
		pop	ix	;restore callers
		ret
.stencil_render
._stencil_render
		push	ix	;save callers
		ld	ix,4
		add	ix,sp

		;call	swapgfxbk

		ld	bc,maxy
		push	bc
.yloop		pop	bc
		dec	bc
		ld	a,b
		and	c
		cp 255
		jr	z,stencil_render_exit
		push	bc
		
		ld	d,b
		ld	e,c

		ld	l,(ix+2)	; stencil
		ld	h,(ix+3)

		add	hl,bc
		add	hl,bc
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

		pop bc
		push bc

		push hl
		
		ld	a,(ix+0)	; intensity
		push de		; X1
		call	dither_pattern
		pop hl		; X1
		ld	(pattern1+1),a
		ld	(pattern2+1),a

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

			ld	d,b
			ld	e,c

			call	w_pixeladdress		; bitpos1 = pixeladdress(x+width-1,y)
			call	rightbitmask		; RightBitMask(bitpos1)
			ld	(bitmaskr+1),a		; bitmask1 = LeftBitMask(bitpos0)

			pop	af	; pattern to be drawn (left-masked)
			pop	hl	; adr0
			ld	b,a
		
			ld	a,h
			cp	d
			jr	nz,noobt
			ld	a,l
			cp e
			jr	z,onebyte
.noobt
			ld	a,b
			ld	(hl),a			; (offset) = (offset) AND bitmask0

         ld     a,16
		 add	l
		 ld		l,a
		 jp		nc,gonehi
		 inc	h
.gonehi

				ld	a,h
				cp	d
				jr	nz,pattern2
				ld	a,l
				cp e
.pattern2			ld	a,0
				jr	z,bitmaskr
			ld	b,a
.fill_row_loop							; do
			ld	a,b
				ld	(hl),a			; (offset) = pattern

         ld     a,16
		 add	l
		 ld		l,a
		 jp		nc,gonehi2
		 inc	h
.gonehi2
         
				ld	a,h
				cp	d
				jr	nz,fill_row_loop
				ld	a,l
				cp e
				jr	nz,fill_row_loop		; while ( r-- != 0 )

.bitmaskr		ld	a,0
			call	mask_pattern
			ld	(hl),a

			jp	yloop


.onebyte
		ld	a,b
		ld	(pattern1+1),a
		jr	bitmaskr


		; Prepare an edge byte, basing on the byte mask in A
		; and on the pattern being set in (pattern1+1)
.mask_pattern
		push	de
		ld	d,a		; keep a copy of mask
		and	(hl)		; mask data on screen
		ld	e,a		; save masked data
		ld	a,d		; retrieve mask
		cpl			; invert it
.pattern1	and	0		; prepare fill pattern portion
		or	e		; mix with masked data
		pop de
		ret

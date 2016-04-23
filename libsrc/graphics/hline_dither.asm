;
;	z88dk GFX library
;
;	Draw a dithered horizontal line basing 
;	its pattern on an 'intensity' parameter.
;	Basic concept by Rafael de Oliveira Jannone
;	
;
;	hline_dither(int x1, int y1, int x2, unsigned char intensity)
;

	SECTION  code_clib
	PUBLIC	surface_hline_dither
	PUBLIC	_surface_hline_dither
	EXTERN	base_graphics

	EXTERN surface_pixeladdress
	EXTERN leftbitmask, rightbitmask

;	
;	$Id: hline_dither.asm,v 1.3 2016-04-23 20:37:40 dom Exp $
;

.surface_hline_dither
._surface_hline_dither
		push	ix
		ld	ix,2
		add	ix,sp
		
		ld	l,(ix+10)	; surface struct
		ld	h,(ix+11)
		ld	de,6		; shift to screen buffer ptr
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	(base_graphics),de

		ld	a,(ix+6)
		and	3
		ld	e,a

		ld	a,(ix+2)
		add	a
		add	a
		add	e,a			; 192+40=232 ..we are still inside the byte
		ld	d,0
		ld	hl,_dithpat
		add	hl,de
		ld	a,(hl)
		;push	af			; save pattern for current line
		ld	(clear_row_loop+1),a
		ex	af,af
		
		ld	h,(ix+8)
		ld	l,(ix+6)


			;ld	a,(ix+4)
			;sub	h
			;ld	b,a
			
			;ld	(coord+1),hl		; SMC: remember y,x
			;inc	b
			;push	bc			; remember height
			;push	bc
			push	hl
			call	surface_pixeladdress		; bitpos0 = surface_pixeladdress(x,y)
			pop	hl
			call	leftbitmask		; LeftBitMask(bitpos0)
			ld	(bitmaskl1+1),a		; SMC
			ld	(bitmaskl2+1),a		; SMC
			;pop	bc
			;ld	a,h
			;add	b
			ld	a,(ix+4)
			;dec	a
			dec	a
			ld	h,a
			push	de
			call	surface_pixeladdress		; bitpos1 = surface_pixeladdress(x+width-1,y)
			call	rightbitmask		; RightBitMask(bitpos1)
			ld	(bitmaskr1+1),a
			ld	(bitmaskr2+1),a		; bitmask1 = LeftBitMask(bitpos0)
			pop	hl
			push	hl			; adr0
			ex	de,hl
			cp	a
			sbc	hl,de			; (adr1-adr0)/8
			ld	a,l
			ld	(rowbytes1+1),a
			ld	(rowbytes2+1),a		; rowbytes = (adr1-adr0) div 8, no. of bytes in row
							; 0 means that area is within same address
							; FOR h = 1 TO height
			pop	hl	; adr0
.clear_height
			xor	a
.rowbytes1		cp	0		; if rowbytes = 0
			jr	nz, clear_row		; area is within one byte...
			ld	a,(hl)
.bitmaskl1		and	0			; preserve bits of leftmost side of byte
			ld	b,a
			ld	a,(hl)
.bitmaskr1		and	0			; preserve bits of rightmost side of byte
			or	b			; merge preserved bits of left side
			ld	(hl),a			; (offset) = byte
			;;jr	clear_nextrow	; else
			jr	end_cleararea
.clear_row						; clear area is defined as rows of bytes
			ld	a,(hl)
.bitmaskl2		and	0			; preserve only leftmost bits (outside of area)
			ld	(hl),a			; (offset) = (offset) AND bitmask0
			inc	hl			; offset += 1 (8 bits)
.rowbytes2		ld	b,0			; r = rowbytes
			dec	b				; --r
			jr	z, row_cleared		; if	( r )
.clear_row_loop							; do
				ld	(hl),0			; (offset) = 0
				inc	hl			; offset += 1 (8 bits)
				djnz	clear_row_loop		; while ( r-- != 0 )
.row_cleared		ld	a,(hl)			; byte = (adr1)
.bitmaskr2		and	0
			ld	(hl),a			; preserve only rightmost side of byte (outside area)

;.clear_nextrow
;.coord			ld	hl,0		; SMC -> y,x
;			inc	l
;			ld	(coord+1),hl	; SMC -> y,x
;			call	surface_pixeladdress
;			ex	de,hl		; put adr0 in hl for next row
;			
;							; END FOR	h
;.height			pop	bc
;			dec	c			; height
;			push	bc
;			jr	nz, clear_height
;			pop	bc

.end_cleararea		pop	ix
			ret









_dithpat:
	
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000

	defb	@00000010
	defb	@00000000
	defb	@00100000
	defb	@00000000

	defb	@00000010
	defb	@10000000
	defb	@00100000
	defb	@00001000

	;defb	@00100010
	;defb	@10001000
	;defb	@00100010
	;defb	@10001000

	defb	@00010100
	defb	@01000001
	defb	@00010100
	defb	@01000001

	;defb	@00010100
	;defb	@01000001
	;defb	@10010100
	;defb	@01001001

	defb	@01000101
	defb	@10101000
	defb	@00010101
	defb	@10101010

	defb	@01010101
	defb	@10101010
	defb	@01010101
	defb	@10101010

	defb	@11011101
	defb	@10101010
	defb	@01110111
	defb	@10101010

	;defb	@11111111
	;defb	@10101010
	;defb	@11111111
	;defb	@10101010

	defb	@11011101
	defb	@01110111
	defb	@11011101
	defb	@01110111

	defb	@11111101
	defb	@01111111
	defb	@11011111
	defb	@11110111

	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111

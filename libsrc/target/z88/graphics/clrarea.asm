	SECTION code_clib
	PUBLIC	cleararea

	EXTERN pixeladdress
	EXTERN leftbitmask, rightbitmask

;
;	$Id: clrarea.asm,v 1.4 2016-04-23 21:05:46 dom Exp $
;

; ***********************************************************************
;
; Clear specified graphics area in map.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
;
; IN:	HL	= (x,y)
;	BC	= (width,heigth)
;
;	  Variables on stack; ix pointer to base of variables:
;
;		(ix+0)	y
;		(ix+1)	height
;		(ix+2,3)	adr0
;
;		(ix+4)	bitmask0		bitmask for leftmost byte of pixel row
;		(ix+5)	bitmask1		bitmask for rightmost byte of pixel row
;		(ix+6)	rowbytes		number of bytes in pixel row to clear
;
; OUT: None. (graphics area is scrolled)
;
; Registers changed after return:
;   ......../IXIY same
;   AFBCDEHL/.... different
;

.cleararea		push	ix
				push	iy
				ld	de,0
				ex	de,hl
				add	hl,sp
				ex	de,hl
				ld	ix,-7
				add	ix,sp		; ix	points at	base	of variables
				ld	sp,ix		; local variable area created
				push	de			; remember pointer to original ix,	iy

				ld	(ix+0),l		; remember y
				ld	(ix+1),c		; remember height
				push	bc
				call	pixeladdress	; adr0, bitpos0 = PixelAddress(x,y)
				ld	(ix+2),e
				ld	(ix+3),d
				call	leftbitmask
				ld	(ix+4),a		; bitmask0 = LeftBitMask(bitpos0)
				pop	bc
				ld	a,h
				add	a,b
				dec	a
				ld	h,a
				push	de
				call	pixeladdress	; adr1, bitpos1 = PixelAddress(x+width-1,y)
				call	rightbitmask
				ld	(ix+5),a		; bitmask1 = LeftBitMask(bitpos0)
				pop	hl
				ex	de,hl
				cp	a
				sbc	hl,de		; (adr1-adr0)
				srl	l
				srl	l
				srl	l
				ld	(ix+6),l		; rowbytes = (adr1-adr0) div 8, no. of bytes in row
								; 0 means that area is within same address
								; FOR h = 1 TO height
.clear_height
				ld	l,(ix+2)
				ld	h,(ix+3)			; offset = adr0
				xor	a
				cp	(ix+6)			; if rowbytes = 0
				jr	nz, clear_row			; area is within one byte...
					ld	a,(hl)
					and	(ix+4)			; preserve bits of leftmost side of byte
					ld	b,a
					ld	a,(hl)
					and	(ix+5)
					ld	c,a
					xor	a				; clear byte
					or	b				; merge preserved bits of left side
					or	c				; merge preserve bits of right side
					ld	(hl),a			; (offset) = byte
					jr	clear_nextrow	; else
.clear_row								; clear area is defined as rows of bytes
					ld	a,(hl)
					and	(ix+4)			; preserve only leftmost bits (outside of area)
					ld	(hl),a			; (offset) = (offset) AND bitmask0
					ld	bc,8
					add	hl,bc			; offset += 8
					ld	b,(ix+6)			; r = rowbytes
					dec	b				; --r
					jr	z, row_cleared		; if	( r )
.clear_row_loop			push	bc				; do
						ld	(hl),0				; (offset) = 0
						ld	bc,8
						add	hl,bc				; offset += 8
						pop	bc
					djnz	clear_row_loop			; while ( r-- != 0 )
.row_cleared			ld	a,(hl)			; byte = (adr1)
					and	(ix+5)
					ld	(hl),a			; preserve only rightmost side of byte (outside area)

.clear_nextrow		inc	(ix+0)			; inc y
				ld	a,(ix+0)
				and	@00000111			; if	y MOD 8 <> 0
				jr	z, clear_newline
					inc	(ix+2)			; inc adr0
					jr	clear_next_h
									; else
.clear_newline			ld	a,(ix+2)
					add	a,256-7
					ld	(ix+2),a
					inc	(ix+3)			; adr0 += 256 (address of start of row)

.clear_next_h		dec	(ix+1)		; END FOR	h
				jp	nz, clear_height

.end_cleararea		pop	hl
				ld	sp,hl		; pointer to original ix, iy
				pop	iy
				pop	ix
				ret

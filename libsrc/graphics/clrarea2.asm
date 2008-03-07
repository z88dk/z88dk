	xlib	cleararea

	lib pixeladdress
	lib leftbitmask, rightbitmask

;
;	$Id: clrarea2.asm,v 1.2 2008-03-07 07:12:09 stefano Exp $
;

; ***********************************************************************
;
; Clear specified graphics area in map.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; Generic SMC version by Stefano Bodrato.
;
;
;
; IN:	HL	= (x,y)
;	BC	= (width,heigth)
;
; Registers changed after return:
;   ......../IXIY same
;   AFBCDEHL/.... different
;

.adr0		defw	0

.cleararea
			ld	(coord+1),hl		; SMC: remember y,x
			inc	b
			push	bc			; remember height
			push	bc
			call	pixeladdress	; adr0, bitpos0 = pixeladdress(x,y)
			ld	(adr0),de
			call	leftbitmask
			ld	(bitmaskl1+1),a		; bitmask0 = LeftBitMask(bitpos0)
			ld	(bitmaskl2+1),a		; bitmask0 = LeftBitMask(bitpos0)
			pop	bc
			ld	a,h
			add	a,b
			dec	a
			ld	h,a
			push	de
			push	hl
			call	pixeladdress	; adr1, bitpos1 = pixeladdress(x+width-1,y)
			pop	hl
			call	rightbitmask
			ld	(bitmaskr1+1),a		; bitmask1 = LeftBitMask(bitpos0)
			ld	(bitmaskr2+1),a		; bitmask1 = LeftBitMask(bitpos0)
			pop	hl
			ex	de,hl
			cp	a
			sbc	hl,de		; (adr1-adr0)
			srl	l
			srl	l
			srl	l
			ld	a,l
			ld	(rowbytes1+1),a
			ld	(rowbytes2+1),a		; rowbytes = (adr1-adr0) div 8, no. of bytes in row
							; 0 means that area is within same address
							; FOR h = 1 TO height
.clear_height
			ld	hl,(adr0)
			xor	a
.rowbytes1		cp	0			; if rowbytes = 0
			jr	nz, clear_row			; area is within one byte...
			ld	a,(hl)
.bitmaskl1		and	0			; preserve bits of leftmost side of byte
			ld	b,a
			ld	a,(hl)
.bitmaskr1		and	0
			ld	c,a
			xor	a				; clear byte
			or	b				; merge preserved bits of left side
			or	c				; merge preserve bits of right side
			ld	(hl),a			; (offset) = byte
			jr	clear_nextrow	; else
.clear_row						; clear area is defined as rows of bytes
			ld	a,(hl)
.bitmaskl2		and	0			; preserve only leftmost bits (outside of area)
			ld	(hl),a			; (offset) = (offset) AND bitmask0
			ld	bc,8
			add	hl,bc			; offset += 8
.rowbytes2		ld	b,0			; r = rowbytes
			dec	b				; --r
			jr	z, row_cleared		; if	( r )
.clear_row_loop			push	bc				; do
				ld	(hl),0				; (offset) = 0
				ld	bc,8
				add	hl,bc				; offset += 8
				pop	bc
				djnz	clear_row_loop			; while ( r-- != 0 )
.row_cleared		ld	a,(hl)			; byte = (adr1)
.bitmaskr2		and	0
			ld	(hl),a			; preserve only rightmost side of byte (outside area)

.clear_nextrow
			push	de
.coord			ld	hl,0		; SMC -> y,x
			inc	l
			ld	(coord+1),hl	; SMC -> y,x
			call	pixeladdress
			ld	(adr0),de
			pop	de
			
.clear_next_h		
			;dec	(height)		; END FOR	h
.height			pop	bc
			dec	c			; height
			push	bc
			jp	nz, clear_height
			pop	bc

.end_cleararea		ret

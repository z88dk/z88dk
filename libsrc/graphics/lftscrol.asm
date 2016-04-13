
	SECTION	code_clib
	PUBLIC	scroll_left

	EXTERN pixeladdress
	EXTERN leftbitmask, rightbitmask

;
;	$Id: lftscrol.asm,v 1.6 2016-04-13 21:09:09 dom Exp $
;

; ***********************************************************************
;
; Scroll specified graphics area leftward horisontally
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; IN:  HL	= (x,y)
;	  BC	= (width,heigth)
;	   A	= scroll distance, 1 to 8 pixels.
;
;	  Variables on	stack; ix	pointer to base of variables:
;		(ix+0)	scroll distance
;		(ix+1)	y
;		(ix+2)	height
;		(ix+3,4)	adr0
;		(ix+5,6)	adr1
;		(ix+7)	bitmask0		bitmask for leftmost byte of pixel	row
;		(ix+8)	bitmask1		bitmask for rightmost byte of	pixel row
;		(ix+9)	rowbytes		number of	bytes in pixel	row to scroll
;		(ix+10)	lastbyte
;
; OUT: None. (graphics area is scrolled)
;
; Registers changed	after return:
;   ......../IXIY same
;   AFBCDEHL/.... different
;
.scroll_left		push	ix
				push	iy
				ld	de,0
				ex	de,hl
				add	hl,sp
				ex	de,hl
				ld	ix,-11
				add	ix,sp		; ix	points at	base	of variables
				ld	sp,ix		; local variable area created
				push	de			; remember pointer to original ix,	iy

				ld	(ix+0),a		; remember scroll distance
				ld	(ix+1),l		; remember y
				ld	(ix+2),c		; remember height
				push	bc
				call	pixeladdress	; adr0, bitpos0 = PixelAddress(x,y)
				ld	(ix+3),e
				ld	(ix+4),d
				call	leftbitmask
				ld	(ix+7),a		; bitmask0 = LeftBitMask(bitpos0)
				pop	bc
				ld	a,h
				add	a,b
				dec	a
				ld	h,a
				push	de
				call	pixeladdress	; adr1, bitpos1 = PixelAddress(x+width-1,y)
				ld	(ix+5),e
				ld	(ix+6),d
				call	rightbitmask
				ld	(ix+8),a		; bitmask1 = LeftBitMask(bitpos0)
				pop	hl
				ex	de,hl
				cp	a
				sbc	hl,de		; (adr1-adr0)
				srl	l
				srl	l
				srl	l
				ld	(ix+9),l		; rowbytes = (adr1-adr0)	div 8, no. of bytes	in row
								; 0 means	that	scroll area is	within same address
								; FOR h =	1 TO	height
.scroll_l_height	ld	iy,0				; offset=0
				ld	e,(ix+3)
				ld	d,(ix+4)			; DE	= adr0
				ld	a,(de)			; byte = (adr0)
				ld	h,a
				ld	l,0
				xor	a
				cp	(ix+9)				; if	rowbytes = 0
				jr	nz, scrollrow_left		; scroll area is within one byte...
					ld	b,(ix+0)
					call	scrollleft		; byte = Scrollleft(byte,0,scrolldist)
					ld	b,h
					ld	l,(ix+7)
					ld	a,l
					cpl					; NOT bitmask0
					and	b
					ld	b,a				; byte = byte AND (NOT bitmask0)
					ld	h,(ix+8)
					ld	a,h
					cpl					; NOT bitmask1
					and	b				; byte = byte AND (NOT bitmask1)
					ld	b,a
					ld	a,(de)
					and	l
					ld	l,a				; byte0 =	(adr0) AND bitmask0
					ld	a,(de)
					and	h				; byte1 =	(adr0) AND bitmask1
					or	b				; byte = byte OR byte1
					or	l				; byte = byte OR byte0
					ld	(de),a			; (adr0) = byte
					jr	leftscroll_nextrow
.scrollrow_left						; else
					push	de				; scroll area is defined	as row of	bytes
					ld	e,(ix+5)
					ld	d,(ix+6)
					ld	a,(de)
					ld	(ix+10),a			; lastbyte = (adr1)
					ld	b,a
					ld	a,(ix+8)			; bitmask1
					cpl
					and	b				; (adr1) = (adr1) AND (NOT bitmask1)
					ld	(de),a			; - preserve only bits within	scroll area
					pop	de				; - the other bits are restored after scroll
					push	iy
					add	iy,de
					ld	l,(iy+8)			; (adr0+8)
					pop	iy

					ld	b,(ix+0)
					call	scrollleft		; byte = Scrollleft(byte,(adr0+8),scrolldist)
					ld	b,h
					ld	a,(ix+7)
					cpl					; NOT bitmask0
					and	b
					ld	b,a				; byte = byte AND (NOT bitmask0)
					ld	c,(ix+7)			; bitmask0
					ld	a,(de)			; byte0 =	(adr0)
					and	c				; byte0 =	byte0 AND	bitmask0
					or	b
					ld	(de),a			; (adr0) = byte0 OR	byte
					ld	bc,8
					add	iy,bc			; offset += 8
					ld	b,(ix+9)			; r = rowbytes

.scroll_row_left_loop	dec	b				; while (	--r != 0 )
					jr	z, endrow_left
					push	bc
					push	iy					; DE	= adr0
					add	iy,de				; adr0+offset
					ld	b,(ix+0)				; scrolldist
					ld	h,(iy+0)				; (adr0+offset)
					ld	l,(iy+8)				; (adr0+offset+8)
					call	scrollleft			; byte = Scrollleft( (adr0+offset),(adr0+offset+8),scrolldist)
					ld	(iy+0),h				; (adr0+offset) = byte
					pop	iy
					ld	bc,8
					add	iy,bc				; offset += 8
					pop	bc
					jr	scroll_row_left_loop

.endrow_left			ld	e,(ix+5)
					ld	d,(ix+6)			; adr1, addr of last byte in row to scroll
					ld	a,(de)			; byte = (adr1)
					ld	h,a
					ld	l,0
					ld	b,(ix+0)
					call	scrollleft		; byte = Scrollleft( (adr1),0,scrolldist)
					ld	a,(ix+8)
					and	(ix+10)			; lastbyte = lastbyte AND bitmask1	: clear scroll	area
					or	h				; mask in	what	has been scrolled, the rest is outside scroll area.
					ld	(de),a			; (adr1) = byte OR lastbyte, last byte of row completed.
									; endif

.leftscroll_nextrow	inc	(ix+1)			; inc y
				ld	a,(ix+1)
				and	@00000111			; if	y MOD 8 <> 0
				jr	z, leftscroll_newline
.inc_l_row			inc	(ix+3)			; inc adr0
					inc	(ix+5)			; inc adr1
					jr	leftscroll_next_h
									; else
.leftscroll_newline		ld	a,(ix+3)
					add	a,256-7
					ld	(ix+3),a
					inc	(ix+4)			; adr0 +=	256
					ld	a,(ix+5)
					add	a,256-7
					ld	(ix+5),a
					inc	(ix+6)			; adr1 +=	256

.leftscroll_next_h	dec	(ix+2)		; END FOR	h
				jp	nz, scroll_l_height

.end_scroll_left	pop	hl
				ld	sp,hl		; pointer	to original ix, iy
				pop	iy
				pop	ix
				ret


; ************************************************************************
;
; Scroll bytes	left, b1 into b0, total of B pixels
;
; IN:  H = b0
;	  L = b1
;	  B = scroll distance, 1	to 8	pixels.
;
; OUT: H = scrolled	byte
;
.scrollleft		add	hl,hl
				djnz	scrollleft
				ret

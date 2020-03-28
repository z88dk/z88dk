        SECTION code_clib
	PUBLIC	pixeladdress

	EXTERN	base_graphics

;
;	$Id: pixladdr.asm,v 1.7 2016-04-23 21:05:46 dom Exp $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; in:  hl	= (x,y) coordinate of pixel (h,l)
;
; out: de	= address	of pixel byte
;	   a	= bit number of byte where pixel is to be placed
;	  fz	= 1 if bit number is 0 of pixel position
;
; registers changed	after return:
;  ......hl/ixiy same
;  afbcde../.... different
;
.pixeladdress			
				ld	b,l
				srl	b
				srl	b
				srl	b				; linedist = y	div 8 * 256
				ld	a,h
				and	@11111000			; rowdist	= x div 8	* 8
				ld	c,a				; bc	= linedist + rowdist
				ld	a,l
				and	@00000111			; coldist	= y mod 8
				ld	de,(base_graphics)	; pointer	to base of graphics	area
				ld	e,a				; coldist	= graphicsarea	+ coldist
				ld	a,h
				ex	de,hl
				add	hl,bc			; bytepos	= linedist + rowdist + coldist
				ex	de,hl
				and	@00000111			; a = x mod 8
				xor	@00000111			; a = 7 -	a
				ret



	XLIB	pixeladdress

	XREF	base_graphics


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
				push	hl
				ld	a,h
				push	af
;				and	@11111000		; rowdist = x div 8 * 8
				rra
				rra
				rra
				and	@00111111

				ld	b,l

				ld	hl,(base_graphics)	; pointer to base of graphics area
				ld	l,a

				ld	de,32
.adder				add	hl,de
				djnz	adder


				ld	d,h
				ld	e,l
				pop	af
				pop	hl
				and	@00000111		; a = x mod 8
				xor	@00000111		; a = 7 - a
				
				ret


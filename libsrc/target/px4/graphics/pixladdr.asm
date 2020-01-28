;
;   Graphics library for the Epson PX4
;   Stefano - Nov 2015
;
;
;	$Id: pixladdr.asm,v 1.3 2016-06-21 20:16:35 dom Exp $
;

	SECTION	code_clib
	PUBLIC	pixeladdress

	INCLUDE	"graphics/grafix.inc"

	EXTERN	base_graphics

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
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


		push	bc
		ld	a,h
		
		push	af
		
		srl	a
		srl	a
		srl	a
		
		ld	c,a	; c=int(x/8)
		
		;ld	b,l
		ld	h,l
		ld  l,0
		srl h
		rr  l
		srl h
		rr  l
		srl h
		rr  l
		
		;ld	de,($f2ad)		; LVRAMYOF
		ld  de,$e000
		add	hl,de
		
		ld	b,0
		
		add	hl,bc
		
		ld	d,h
		ld	e,l
		pop	af
		pop	bc
		
		and	@00000111		; a = x mod 8
		xor	@00000111		; a = 7 - a
		
		ret

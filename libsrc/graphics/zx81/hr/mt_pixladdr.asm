;--------------------------------------------------------------
; ZX81 HRG library for the Memotech expansion
; by Stefano Bodrato, Feb. 2010
;--------------------------------------------------------------
;
;	$Id: mt_pixladdr.asm,v 1.3 2015-01-19 01:32:52 pauloscustodio Exp $
;

	PUBLIC	pixeladdress

	;;XREF	base_graphics


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

	; add y-times the nuber of bytes per line (33)
	ld	a,h
	ld	b,a

	ld	h,0
	ld	d,h
	ld	e,l

	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	inc	hl
	inc	hl

	ld		de,($407B)
	;;ld	de,(base_graphics)
	add	hl,de

	; add x divided by 8
	
	;or	a
	rra
	srl a
	srl a
	ld	e,a
	ld	d,0
	add	hl,de
	
	ld	d,h
	ld	e,l

	ld	a,b
	and	7
	xor	7
	
	ret

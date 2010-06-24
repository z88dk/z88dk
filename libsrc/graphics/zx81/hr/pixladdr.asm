;--------------------------------------------------------------
; Part of this code comes from the 'HRG_Tool' 
; by Matthias Swatosch
;--------------------------------------------------------------


	XLIB	pixeladdress

	XREF	base_graphics

;
;	$Id: pixladdr.asm,v 1.3 2010-06-24 09:05:51 stefano Exp $
;

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

	; add y-times the nuber of bytes per line (32)
	; or just multiply y by 32 and the add
	ld	e,l
	ld	a,h
	ld	b,a

	ld	h,0

	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl

	ld	de,(base_graphics)
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

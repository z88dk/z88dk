;--------------------------------------------------------------
; Part of this code comes from the 'HRG_Tool' 
; by Matthias Swatosch
;--------------------------------------------------------------


	XLIB	pixeladdress

	XREF	base_graphics

;
;	$Id: pixladdr.asm,v 1.1 2007-10-04 10:28:47 stefano Exp $
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

	push	hl

	; add y-times the nuber of bytes per line (32)
	; or just multiply y by 32 and the add
	ld	d,0
	ld	e,l
	ld	c,h
	
	or	a
	rl	e
	rl	d
	or	a
	rl	e
	rl	d
	or	a
	rl	e
	rl	d
	or	a
	rl	e
	rl	d
	or	a
	rl	e
	rl	d
	ld	hl,(base_graphics)
	add	hl,de

	; add x divided by 8
	or	a
	srl	c
	srl	c
	srl	c
	ld	b,0
	add	hl,bc
	
	ex	de,hl

	pop	hl

	ld	a,h
	and	7
	xor	7
	
	ret

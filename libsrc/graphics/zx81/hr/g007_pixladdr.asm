;--------------------------------------------------------------
; Part of this code comes from the 'HRG_Tool' 
; by Matthias Swatosch
;--------------------------------------------------------------

	SECTION code_clib
	PUBLIC	pixeladdress

	EXTERN	base_graphics

;
;	$Id: g007_pixladdr.asm,v 1.4 2016-06-27 20:26:33 dom Exp $
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

	; add y-times the nuber of bytes per line (34)
	; or just multiply y by 34
	ld	e,l
	ld	a,h
	ld	b,a

	ld	h,0

	add	hl,hl
	ld	d,h
	ld	e,l
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl

	add	hl,de

	ld	de,9
	add hl,de

	ld	de,(base_graphics)
;	ld	hl,(2308h)
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
	or	0f8h	;set all unused bits 1
	cpl			;they now become 0
	
	ret
